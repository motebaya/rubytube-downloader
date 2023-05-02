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
        @shortUrl = url
        @default_quality = default_quality
        @host = "https://ytshorts.savetube.me/"
        @api = "https://cdn69.savetube.me"
        @headers = 	{
            "Host":"api.savetube.me",
            "User-Agent": @userAgent[:linux],
            "Accept": "*/*",
            "Origin": @host,
            "Referer": @host
        }
        @output = getOutput(path)
        @cli = cli
        @formats = !formats.nil? ? formats : 'video' # the default formats is video
        @shortId = check_url(@shortUrl)[1] #url.match(%r"shorts\/([\w]+)").to_s
    end

    def analyze
        page = getPage("#{@api}/info", @headers, {'url': @shortUrl})
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
                if @cli
                    return response
                end

                return JSON.dump(response)
            else
                return nil
            end
        else
            abort(js.to_s)
        end
    end

    def extract(quality=nil, response=nil)
        # CLI handler
        if (!quality && !response)
            logger("savetube", "downloading webpage: #{@shortId}")
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
                        logger("savetube", "skipped: nothing `#{@defaul_quality}` for #{@shortId}.")
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
                        abort(data.to_s)
                    end
                else
                    abort(" [savetube-err] Must < #{data['res'].length}!!")
                end
            else
                abort(data.to_s)
            end
        else
            # return as JSON string if set @cli to false
            response = loadJson(response)
            if (response[:res].map { |qual| qual.split('->')[0].strip}).include?(quality.to_s)
                jResponse = loadJson(
                    getPage(
                        sprintf(
                            "%s/download/%s/%s/%s", @api, response[:format],
                            quality.to_s, response[:key]
                        )
                    )
                )
                if (jResponse['status'] && jResponse['message'].to_i == 200)
                    return JSON.dump(jResponse)
                end
            else
                return JSON.dump({
                    "error": "invalid quality"
                })
            end
        end
    end
end
