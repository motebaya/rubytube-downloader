#!/usr/bin/ruby
# Tue June 10 10:44:16 2022
# from ytshorts.savetube.me cli/module version
# © Copyright 2022.06 github.com/motebaya
# update : tue may.02.2023 09:42:26 AM

class SaveTube < Helper

    attr_reader :shortUrl, :shortId, :formats, :output
    """
    @params: 
        - url (str): youtube video/shorts url
        - formats (str): audio or video
        - output (str): output path location to save, default: current dir
    """
    def initialize(
        url=nil, 
        formats=nil, 
        path=nil, 
        cli=false, 
        default_quality=nil
    )
        super()
        @youtubeUrl = url
        @default_quality = default_quality
        @host = "https://ytshorts.savetube.me/"
        # this cdn host may sometime will change
        @api = "https://cdn69.savetube.me"
        @headers = 	{
            "Host":"api.savetube.me",
            "User-Agent": @userAgent[:linux],
            "Accept": "*/*",
            "Origin": @host,
            "Referer": @host
        }
        @output = !path.nil? ? getOutput(path) : path
        @cli = cli
        @formats = !formats.nil? ? formats : 'video' # the default formats is video
        @youtubeid = !url.nil? ? check_url(url)[1] : ""
    end

    # get info from api
    def analyze
        page = getPage("#{@api}/info", @headers, {'url': @youtubeUrl})
        js = loadJson(page.to_s)
        if (js["status"] and js['message'].to_i == 200)
            if (["audio","video"].include?(@formats))
                # extract the info
                response = {
                    "key" => js['data']['key'],
                    "title" => js['data']['title'],
                    "format" => @formats,
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
            return {
                "status" => "404"
            }
        end
    end

    # extraction func
    def extract(
        formats=nil,
        quality=nil,
        token=nil
    )
        # CLI handler
        if (![formats, quality, token].all?)
            logger("savetube", "downloading webpage: #{@youtubeid}")
            data = analyze
            # puts data
            if (!data.nil?)
                logger("savetube", "Title: #{data['title']}")
                logger("savetube", "list quality:")
                puts

                dformats = nil
                data["res"].each_with_index do | label, index |
                    printf(
                        " \033[1;32m[\033[0m%02d\033[1;32m]\033[0m. %s\n", index + 1, label
                    )
                    # check default quality set
                    if (dformats.nil? && !@default_quality.nil?)
                        if label.include?(@default_quality)
                            dformats = index + 1
                        end
                    end
                end
                puts

                if dformats.nil?
                    if @default_quality.nil?
                        dformats = prompt(" \033[1;32m[\033[0msavetube\033[1;32m]\033[0m Set : ").to_i
                    else
                        logger("savetube", "skipped: nothing `#{@defaul_quality}` for #{@youtubeid}.")
                        return
                    end
                end

                if (dformats - 1) < data['res'].length
                    choicedFormats = data['res'][dformats - 1]
                    logger("savetube", "converting to: #{choicedFormats}")
                    res = choicedFormats.split('->')[0].strip
                    filename = data['title'] + (@formats == 'audio' ? '.mp3' : '.mp4')
                    logger("savetube", "downloading: #{filename}")
                    # start converting
                    get_link = loadJson(getPage("#{@api}/download/#{@formats}/#{res}/#{data['key']}", headers=@headers).to_s)
                    if (get_link['status'] and get_link['message'].to_i == 200)
                        download_stream(
                            get_link['data']['downloadUrl'],
                            filename,
                            @output
                        )
                        logger("savetube", "saved as: #{@output}#{filename}")
                        puts
                    else
                        puts data.to_s
                        return
                    end
                else
                    logger("savetube", " must < #{data['res'].length}!!")
                end
            else
                puts data.to_s
                return
            end
        else
            # just return to convert page
            return getPage(
                     sprintf(
                         "%s/download/%s/%s/%s", @api, formats,
                         quality, token
                     )
                )
        end
    end
end
