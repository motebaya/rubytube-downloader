#!/usr/bin/ruby
# Tue May 31 02:44:16 2022
# youtube media downlaoder with js parser method
# nothing spesific media type like what do you want!.
# read Markdown file for more details.
# © Copyright 2022.06 github.com/motebaya

class YoutubeCom < Helper

    attr_reader :shorts_url, :path, :shorts_id, :formats, :adaptiveFormats
    def initialize(url="", path=nil, cli=false)
        super()
        @shorts_url = url
        @cli = cli
        @shorts_id = url.match(%r"shorts\/([\w]+)").to_s
        @path = getOutput(path)
        @formats = []
        @adaptiveFormats = []
    end

    def analyze
        page = getPage(@shorts_url)
        formats = []
        adaptiveFormats = []
        # parse JSON from javascript source
        if (js = page.match(%r"(?<=ytInitialPlayerResponse\s=\s)(.*?)(?=;(?:var\smeta|<\/script>))"))
            data = loadJson(js.to_s)
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
                    # return as json
                    return {
                        "author" => video_info["author"],
                        "title" => video_info["title"],
                        "duration" => video_info["lengthSeconds"],
                        "tags" => tags.join(', '),
                        "description" => video_info["shortDescription"],
                        "formats" => @formats,
                        "adaptive_formats" => @adaptiveFormats
                    }
                else
                    return false
                end
            else
                return false
            end
        else
            abort(" •! failed get js data!")
        end
    end

    def extract
        json_data = analyze
        if @cli
            logger("youtube", "downloading webpage: #{@shorts_id}")
            if json_data
                json_data.each do | key, value |
                    if (!['description', 'formats', 'adaptive_formats'].include?(key)) # skip desc,too long
                        logger(
                            "youtube", "#{key}: #{value}"
                        )
                    end
                end

                puts
                printf(
                    " ~ 1). Audio With Video (%s)\n ~ 2). Audio / Video Only (%s)\n",
                    @formats.length.to_s, @adaptiveFormats.length.to_s
                )
                puts
                choice = prompt(" ~ Set : ")
                all_formats = [@formats, @adaptiveFormats]
                if (choice.to_i - 1) < all_formats.length
                    index_formats = all_formats[choice.to_i-1]
                    puts
                    puts " ~ .format> (:type, :quality, :bitrate)\n"
                    index_formats.each_with_index do | string, index |
                        printf(
                            " ~ \033[32m(\033[0m%i\033[32m)\033[0m. %s - %s - %s \n",
                            index + 1, string['type'], string['quality'], string['bitrate']
                        )
                    end
                    puts
                    choice = prompt(" ~ Set: ")
                    if (choice.to_i - 1) < index_formats.length
                        index_choice = index_formats[choice.to_i - 1]
                        filename = json_data["title"] + "." + index_choice["type"].split("/")[-1]
                        logger("youtube", "downloading: #{filename}")
                        if (!index_choice["link"].nil?)
                            download_stream(
                                index_choice["link"],
                                filename,
                                @path
                            )
                            logger("youtube", "Saved as: #{@path}#{filename}")
                        else
                            abort(" •! exception with signatureCipher, try other shorts url!")
                        end
                    else
                        abort(" •! must be < #{index_formats.length}")
                    end
                else	
                    abort(" •! must be < #{all_formats.length}")
                end
            else
                abort('failed get video info!')
            end
        else
            return JSON.dump(json_data)
        end
    end
end

# data = YoutubeCom.new("https://www.youtube.com/shorts/fwslN9doKDY", "./", false).extract()
# puts data
