#!/usr/bin/ruby
# Tue May 31 02:44:16 2022
# youtube media downlaoder with js parser method
# this is real get from youtube source, 
# nothing spesific media type like what do you want!.
# read Markdown file for more details.
# © Copyright 2022.06 github.com/valsztrax

require File.join(
    File.dirname(
        __FILE__), "function")

require File.join(
    File.dirname(
        __FILE__), "downloader_file")

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
    end

    def parseJS(page)
        formats = []
        adaptiveFormats = []
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
            abort(" •! failed get js data!")
        end
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
                    if (! index_choice["link"].nil?)
                        download_stream(
                            index_choice["link"],
                            filename,
                            @path
                        )
                        puts " [yshort] saved as: #{@path}#{filename}"
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
    end
end

