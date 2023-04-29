#!/usr/bin/ruby
# ruby downloader with ruby-progressbar and httparty
# thanks for :
# 	@jinghea: https://github.com/jinghea/rget
#	@jfelchner: https://github.com/jfelchner/ruby-progressbar
#	@https://github.com/jnunemaker/httparty
# © Copyright 2022.06 github.com/motebaya

require "ruby-progressbar"
require "httparty"

class Integer
    def to_filesize
        {
            'B'=> 1024,
            'KB' => 1024 * 1024,
            'MB' => 1024 * 1024 * 1024,
            'GB' => 1024 * 1024 * 1024 * 1024,
            'TB' => 1024 * 1024 * 1024 * 1024 * 1024
        }.each_pair { |e, s| 
            return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s
        }
    end
end

class ProgressRunner
    def initialize(total)
        @total = total
        @progress = 0
        @progress_bar = ProgressBar.create(
            :total => @total,
            :format => "%a %b\u{15E7}%i %p%% %t",
            :progress_mark => ' ',
            :remainder_mark => "\u{FF65}"
        )
        set_title
    end

    def download(segment)
        begin
            yield
            if @progress < @total
                @progress += segment
                @progress = @total if @progress > @total
                set_title
                @progress_bar.progress = @progress
            elsif @progress == 0
                @progress_bar.finish
            end
        rescue
            @progress_bar.stop
            raise
        end
    end

    def set_title
        @progress_bar.title = "#{@progress.to_i.to_filesize}/#{@total.to_i.to_filesize}"
    end
end

def download_stream(url, name, path)
    if File.directory?(path)
        name = name.gsub(/(?:\?|\/|\|)/,'_')
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
