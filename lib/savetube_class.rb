#!/usr/bin/ruby
# Tue June 10 10:44:16 2022
# from ytshorts.savetube.me cli/module version
# © Copyright 2022.06 github.com/motebaya
# update : Thu Apr 27 02:30:18 PM 2023

class SaveTube < Helper

    attr_reader :shortUrl, :shortId, :formats, :output
    """
    @params: 
        - url (str): youtube video/shorts url
        - formats (str): audio or video
        - output (str): output path location to save, default: current dir
    """
    def initialize(url=nil, formats=nil, path=nil, cli=false)
        super()
        @shortUrl = url
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
        @formats = !formats.nil? ? formats : 'video'
        @shortId = url.match(%r"shorts\/([\w]+)").to_s
    end

    def analyze
        page = getPage("#{@api}/info", @headers, {'url': @shortUrl})
        js = loadJson(page.to_s)
        if (js["status"] and js['message'].to_i == 200)
            if (["audio","video"].include?(@formats))
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
            if (!data.nil?)
                logger("savetube", "Title: #{data['title']}")
                logger("savetube", "list quality:")
                puts
                data["res"].each_with_index do | label, index |
                    printf(
                        " (%d). %s\n", index + 1, label
                    )
                end
                puts
                quality = prompt(" (savetube) Set : ").to_i
                if (quality - 1) < data['res'].length
                    res = data['res'][quality - 1].split('->')[0].strip
                    filename = data['title'] + (@formats == 'audio' ? '.mp3' : '.mp4')
                    logger("savetube", "downloading: #{filename}")
                    get_link = loadJson(getPage("#{@api}/download/#{@formats}/#{res}/#{data['key']}", headers=@headers).to_s)
                    if (get_link['status'] and get_link['message'].to_i == 200)
                        download_stream(
                            get_link['data']['downloadUrl'],
                            filename,
                            @output
                        )
                        logger("savetube", "file saved in: #{@output}#{filename}")
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
                abort("invalid quality")
            end
        end
    end
end

