#!/usr/bin/ruby
# Tue June 10 10:44:16 2022
# from ytshorts.savetube.me cli version
# read Markdown file for more details.
# © Copyright 2022.06 github.com/valsztrax

require File.join(
	File.dirname(
		__FILE__),"function")
require File.join(
	File.dirname(
		__FILE__), "downloader_file")

class SaveTube

	attr_reader :shortUrl, :shortId, :formats, :output
	def initialize(url=nil, formats=nil, path=nil)
		@shortUrl = url
		@host = "https://ytshorts.savetube.me/"
		@api = "https://api.savetube.me"
		@headers = 	{
			"Host":"api.savetube.me",
			"User-Agent":"Mozilla/5.0 (Linux; Android 11; Infinix X6810 Build/RP1A.200720.011;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/102.0.5005.78 Mobile Safari/537.36",
			"Accept": "*/*",
			"Origin": @host,
			"Referer": @host
		}
		@output = !path.nil? ? path : File.realpath(File.dirname(".")) + "/" # set default path where u running bin file
		@formats = !formats.nil? ? formats : 'video'
		@shortId = url.match(%r"shorts\/([\w]+)").to_s
	end

	def save_tubes
		page = getPage("#{@api}/info", @headers, {'url': @shortUrl})
		js = loadJson(page.to_s)
		if (js["status"] and js['message'].to_i == 200)
			if (["audio","video"].include?(@formats))
				response = {
					"key" => js['data']['key'],
					"title" => js['data']['title'],
					"res" => js['data']["#{@formats}_formats"].map { | v | 
						"%s -> %s" % [
							v.has_key?("height") ? v['height'] : v['quality'],
							v['label']
						]
					}
				}
				response["res"] = (@formats == 'video' ? response['res'].slice(1...) : response['res'])
				return response
			else
				return nil
			end
		else
			abort(js.to_s)
		end
	end

	def Main
		puts "\n [savetube] downloading webpage: #{@shortId}"
		data = save_tubes
		if (!data.nil?)
			puts " [savetube] Title: #{data['title']}\n [savetube] List quality: "
			puts
			data["res"].each_with_index do | label, index |
				puts " (#{index+1}). #{label}"
			end
			puts
			quality = prompt(" [savetube] Set : ").to_i
			if (quality - 1) < data['res'].length
				res = data['res'][quality - 1].split('->')[0].strip
				filename = data['title'] + (@formats == 'audio' ? '.mp3' : '.mp4')
				puts " [savetube] downloading files: #{filename}"
				get_link = loadJson(getPage("#{@api}/download/#{@formats}/#{res}/#{data['key']}", headers=@headers).to_s)
				if (get_link['status'] and get_link['message'].to_i == 200)
					download_stream(
						get_link['data']['downloadUrl'],
						filename,
						@output
					)
					puts " [savetube] file saved in: #{@output}#{filename}"
				else
					abort(data.to_s)
				end
			else
				abort(" [savetube-err] Must < #{data['res'].length}!!")
			end
		else
			abort(data.to_s)
		end
	end
end

