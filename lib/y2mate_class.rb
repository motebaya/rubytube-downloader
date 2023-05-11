#!/usr/bin/ruby
# y2mate clas from y2mate.com
# date: Tue May.02.2023 09:50:35 AM
# @copyright: github.com/motebaya

class Y2mate < Helper
    # y2mate no need @param formats
    def initialize(url=nil, path=nil, cli=false, default_quality=nil)
        super()
        @cli = cli
        @url = url
        @default_quality = default_quality
        @path = !path.nil? ? getOutput(path): path
        @host = "https://www.y2mate.com"
        @theaders = {
            'Host' => 'www.y2mate.com',
            'UserAgent' => @userAgent[:linux],
            'Content-Type' => 'application/x-www-form-urlencoded'
        }
        @youtubeid = !url.nil? ? check_url(url)[1] : ''
    end

    def analyze
        begin
            response = postPage("#{@host}/mates/analyzeV2/ajax",
                @theaders,{k_query: @url, q_auto: 1})
            data = []
            json = loadJson(response.to_s)
            if json['status'].downcase == "ok"
                for key in json['links'].keys
                    for formatKey in json['links'][key].keys
                        get = json['links'][key][formatKey]
                        data.append({
                            'size': !get['size'].empty? ? get['size'] : '-',
                            'quality': get['q_text'].gsub(/<[^>]*>/, ''),
                            'format': get['f'],
                            'key': URI.encode_uri_component(get['k'])
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

	# only convert from ID and token
	def convert(youtubeid, token)
		return postPage(
            "#{@host}/mates/convertV2/index",
 	           @headers, {
				vid: youtubeid,
				k: URI.decode_uri_component(token)
			}
        ).to_s
	end

    def extract
        data = analyze
        if @cli
            logger("y2mate", "downloading webpage: #{@youtubeid}")
            if (!data.nil?)
                logger("y2mate", "author: #{data[:author]}")
                logger("y2mate", "title: #{data[:title]}")
                puts
                logger("y2mate", "format: size, quality, format.")
                puts
                dformats = nil
                data[:media].each_with_index do | value, index |
                    size = value[:size]
                    if (!size.match?(/\d/) || size.length == 0)
                        size = "-"
                    end

                    printf(
                        " \033[1;32m[\033[0m%02d\033[1;32m]\033[0m. %s, %s, %s\n",
                        index + 1, size, value[:quality], value[:format]
                    )

                    # deafult quality check
                    if !@default_quality.nil?
                        if value[:quality].strip.include?(@default_quality) && dformats.nil?
                            dformats = index + 1
                        end
                    end

                end
                # puts

                # if nothing, do prompt
                if dformats.nil?
                    if @default_quality.nil?
                        # puts
                        dformats = prompt(" \033[1;32m[\033[0my2mate\033[1;32m]\033[0m choice: ").to_i
                    else
                        logger(
                            "y2mate",
                            "Skipped: #{@default_quality} not found for #{data[:videoId]}!"
                        )
                        return
                    end
                end

                if (dformats - 1) < data[:media].length
                    choiced = data[:media][dformats - 1]
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
                        puts
                    end
                else
                    logger("y2mate", "must be < #{data[:media].length}")
                    return
                end
            else
                puts data
                logger("y2mate", "skiping -> #{@youtubeid}")
                return
            end
        else
            return JSON.dump(data)
        end
    end
end
