#!/usr/bin/ruby
# Tue May 31 02:44:16 2022
# youtube media downlaoder with js parser method
# this is real get from youtube source, 
# nothing spesific media type like what do you want!.
# read Markdown file for more details.
# © Copyright 2022.06 github.com/valsztrax

require "httparty"
require "json"
require "ruby-progressbar"
require "optparse"
require File.join(
	File.dirname(
		__FILE__), "downloader_file")

@banner = %{
            ╦ ╦┌─┐┬ ┬┌─┐┬─┐┌┬┐╦═╗┌┐ 
            ╚╦╝└─┐├─┤│ │├┬┘ │ ╠╦╝├┴┐
             ╩ └─┘┴ ┴└─┘┴└─ ┴o╩╚═└─┘
   [ a simple ruby youtube short downloader ]
           [ github.com/valsztrax ]
} 

class YoutubeShort

	attr_reader :shorts_url, :path, :shorts_id, :formats, :adaptiveFormats
	def initialize(url="", output=nil)
		@shorts_url = url
		@shorts_id = url.match(%r"shorts\/([\w]+)").to_s
		if (! output.nil?)
			@path = output
		else
			@path = File.realpath(File.dirname(".")) + "/" # set default path where u running bin file
		end
		@formats = []
		@adaptiveFormats = []
		@uagent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36 Edg/101.0.1210.53 [ip:89.217.147.131]'
#		Main()
	end

	def getPage(url)
		begin
			return HTTParty.get(url, 
				:headers => {
					'user-agent': @uagent}).body
		rescue SocketError
			abort("no internet connection!")
		end
	end

	def parseJS(page)
		formats = []
		adaptiveFormats = []
		begin
			if (js = page.match(%r"(?<=ytInitialPlayerResponse\s=\s)(.*?)(?=;(?:var\smeta|<\/script>))"))
				data = JSON.parse(js.to_s)
				if (data.has_key?("playabilityStatus"))
					if (data["playabilityStatus"]["status"].downcase == "ok")
						["formats","adaptiveFormats"].each { | format |
							data["streamingData"][format].each { | stream |
								quality = if stream.has_key?("qualityLabel") then stream["qualityLabel"] else "" end
								opts = {
									"link" => stream["url"],
									"type" => stream["mimeType"].split(";")[0],
									"quality" => quality,
									"bitrate" => stream["bitrate"]
								}
								eval %{
									if !@#{format}.include?(opts)
										@#{format}.append(opts)
									end
								}
										
							}
						}

						video_info = data["videoDetails"]
						tags = video_info.has_key?("keywords") ? video_info["keywords"] : []
						return {
							"author" => video_info["author"],
							"title" => video_info["title"],
							"duration" => video_info["lengthSeconds"],
							"tags" => tags.join(', '),
							"description" => video_info["shortDescription"]
						}
					else
						return false
					end
				else
					return false
				end
			else
				abort("failed get js data!")
			end
		rescue ParseError => e
			abort("#{e.message}")
		end
	end

	def prompt(*args)
		print(*args)
    	gets
	end

	def Main
		puts "\n [yshort] downloading webpage: #{@shorts_id}"
		if (json_data = parseJS(getPage(@shorts_url)))
			json_data.each do | key, value |
				puts " [yshort] #{key.gsub(/\w+/) do | word | word.capitalize end} : #{value}"
			end
			puts "\n 1). Audio with video (#{@formats.length()})\n 2). Audio / Video only (#{@adaptiveFormats.length()})\n"
			choice = prompt "\n • choice : "
			puts
			all_formats = [@formats, @adaptiveFormats]
			if (choice.to_i - 1) < all_formats.length
				index_formats = all_formats[choice.to_i-1]
				puts "         [:type, :quality, :bitrate] \n\n"
				index_formats.each_with_index do | string, index |
					puts " #{index + 1}). #{string['type']} / #{string['quality']} / #{string['bitrate']}"
				end
				choice = prompt "\n • choice : "
				if (choice.to_i - 1) < index_formats.length
					index_choice = index_formats[choice.to_i - 1]
					filename = json_data["title"] + "." + index_choice["type"].split("/")[-1]
					puts " [yshort] downloading files: #{filename}"
					download_stream(
						index_choice["link"],
						filename,
						@path
					)
					puts " [yshort] saved as: #{@path}#{filename}"
				else
					abort(" •! must be < #{index_formats.length}")
				end
			else	
				abort(" •! must be < #{all_formats.length}")
			end
		else
			abort('failed get video info!')
		end
	end
end

