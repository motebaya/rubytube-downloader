#!/usr/bin/ruby
# update: Tue 02.2023 09:54:25 AM WIB
# nothing spesific media type like what do you want!.
# read Markdown file for more details.
# © Copyright 2022.06 github.com/motebaya

class YoutubeCom < Helper

    attr_reader :shorts_url, :path, :shorts_id, :formats, :adaptiveFormats
    def initialize(url="", path=nil, cli=false, default_quality=nil)
        super()
        @shorts_url = url
        @cli = cli
        @default_quality = default_quality
        @shortid = check_url(url)[1] #url.match(%r"shorts\/([\w]+)").to_s
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
            logger("youtube", "downloading webpage: #{@shortid}")
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
                    " \033[1;32m[\033[0m01\033[1;32m]\033[0m. Audio With Video (%s)\n \033[1;32m[\033[0m02\033[1;32m]\033[0m. Audio / Video Only (%s)",
                    @formats.length.to_s, @adaptiveFormats.length.to_s
                )
                puts

                all_formats = [
                    @formats,
                    @adaptiveFormats
                ]
                
                # adaptive or nonadaptive?
                dformats = !@default_quality.nil? ? (
                    @default_quality.include?(
                        "nonadaptive") ? 1: 2) : @defaul_quality

                if @default_quality.nil?
                    puts
                    dformats = prompt(" \033[1;32m[\033[0myoutube\033[1;32m]\033[0m choice: ")
                end

                if (dformats.to_i - 1) < all_formats.length
                    cformats = nil
                    index_formats = all_formats[dformats.to_i-1]
                    puts
                    puts " \033[1;32m[\033[0myoutube\033[1;32m]\033[0m format> (:type, :quality, :bitrate)\n"
                    puts
                    index_formats.each_with_index do | string, index |
                        printf(
                            " \033[1;32m[\033[0m%02d\033[1;32m]\033[0m. %s - %s - %s \n",
                            index + 1, string['type'], string['quality'], string['bitrate']
                        )
                        
                        # check quality
                        if !@default_quality.nil?
                            if string['quality'].include?(
                                    @default_quality.split('_')[-1]
                                ) && cformats.nil?
                                cformats = index + 1
                            end
                        end

                    end
                    puts

                    if cformats.nil?
                        if @default_quality.nil?
                            cformats = prompt(" \033[1;32m[\033[0myoutube\033[1;32m]\033[0m choice: ")
                        else
                            logger("youtube", "nothing #{@default_quality} for #{@shortid}")
                            return
                        end
                    end

                    if (cformats.to_i - 1) < index_formats.length
                        index_choice = index_formats[cformats.to_i - 1]
                        filename = json_data["title"] + "." + index_choice["type"].split("/")[-1]
                        logger("youtube", "downloading: #{filename}")
                        if (!index_choice["link"].nil?)
                            download_stream(
                                index_choice["link"],
                                filename,
                                @path
                            )
                            logger("youtube", "Saved as: #{@path}#{filename}")
                            puts
                        else
                            logger("youtube", "\033[1;31mexception with signatureCipher, try other shorts url\033[0m!")
                            return
                        end
                    else
                        logger("youtube", "must be < #{index_formats.length}")
                        return
                    end
                else	
                    logger("youtube", "must be < #{all_formats.length}")
                    return
                end
            else
                logger("youtube", "failed get video info!")
                return
            end
        else
            return JSON.dump(json_data)
        end
    end
end