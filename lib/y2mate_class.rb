#!/usr/bin/ruby
# y2mate clas from y2mate.com
# date: Sat Apr 29 11:02:38 PM 2023
# @copyright: github.com/motebaya

class Y2mate < Helper
	# y2mate no need @param formats
	def initialize(url, path=nil, cli=false)
		super()
		@cli = cli
		@url = url
		@path = getOutput(path)
		@host = "https://www.y2mate.com"
		@theaders = {
			'Host' => 'www.y2mate.com',
			'UserAgent' => @userAgent[:linux],
			'Content-Type' => 'application/x-www-form-urlencoded'
		}
	end

	def analyze
		begin
			response = postPage("#{@host}/mates/analyzeV2/ajax",
				@theaders,{k_query: @url, q_auto: 1})
			data = []
			# response = File.open("y2mate_analyze.json", "r").read
			json = loadJson(response.to_s)
			if json['status'].downcase == "ok"
				for key in json['links'].keys
					for formatKey in json['links'][key].keys
						get = json['links'][key][formatKey]
						data.append({
							'size': get['size'],
							'quality': get['q_text'].gsub(/<[^>]*>/, ''),
							'format': get['f'],
							'key': get['k']
						})
					end
				end
				return {
					"videoId": json['vid'],
					"author": json['a'],
					"title": json['title'],
					"media": data
				}
			else
				return nil
			end
		rescue Exception => e
			puts e.message
			exit
		end
	end

	def extract
		data = analyze
		if @cli
			logger("y2mate", "downloading webpage: #{check_url(@url)[1]}")
			if (!data.nil?)
				logger("y2mate", "author: #{data[:author]}")
				logger("y2mate", "title: #{data[:title]}")
				puts "\n ~ >format: size, quality, format.\n\n"
				data[:media].each_with_index do | value, index |
					size = value[:size]
					if (!size.match?(/\d/) || size.length == 0)
						size = "-"
					end

					printf(
						" \033[32m(\033[0m%i\033[32m)\033[0m. %s, %s, %s\n",
						index + 1, size, value[:quality], value[:format]
					)
				end
				puts
				formats = prompt(" ~ choice: ").to_i
				if (formats - 1) < data[:media].length
					choiced = data[:media][formats - 1]
					logger("y2mate", "converting to: #{choiced[:quality]}")

					# post convert APIs
					convert = postPage(
						"#{@host}/mates/convertV2/index",
						@headers, {vid: data[:videoId], k: choiced[:key]}
					).to_s
					jConvert = loadJson(convert)
					if jConvert["status"].downcase == "ok"
						filename = sprintf(
							"%s.%s", data[:title], choiced[:format]
						)
						logger("y2mate", "downloading: #{filename}")
						download_stream(
							jConvert["dlink"],
							filename,
							@path
						)
        				logger("y2mate", "Saved as: #{@path}#{filename}")
					end
				end
			end
		end
	end
end

#call
# Y2mate.new("https://www.youtube.com/shorts/fwslN9doKDY", "video", "./", true).extract()
