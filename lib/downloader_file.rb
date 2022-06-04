#!/usr/bin/ruby
# ruby downloader with ruby-progressbar and httparty
# thanks for :
# 	@jinghea: https://github.com/jinghea/rget
#	@jfelchner: https://github.com/jfelchner/ruby-progressbar
#	@https://github.com/jnunemaker/httparty
# © Copyriht 2022.06 github.com/valzstrax

class ProgressRunner
	def initialize(total)
		@total = total
		@progress = 0
		@progress_bar = ProgressBar.create(
			:title => "downloading!",
			:total => @total,
			:format => "%a %b\u{15E7}%i %p%% %t", # pacmann format
			:progress_mark => ' ',
			:remainder_mark => "\u{FF65}"
		)
	end

	def download(segment)
		begin
			yield
			if @progress < @total
				@progress += segment
				@progress = @total if @progress > @total
				@progress_bar.progress = @progress
			elsif @progress == 0
				@progress_bar.finish
			end
		rescue
			@progress_bar.stop
			raise
		end
	end
end

def download_stream(url, name, path)
	name = name.gsub(/(?:\?|\/)/,"_") # replace invalid file name
	if File.directory?(path)	
		length = HTTParty.head(url)["content-length"].to_i
		progress_runner = ProgressRunner.new(length)
		File.open("#{path}#{name}",'wb') do | file |
			HTTParty.get(url, stream_body: true) do | segment |
				progress_runner.download(segment.length) do
					file.write(segment)
				end
			end
		end
	else
		raise Errno, "Path #{path} not found!"
	end
end
