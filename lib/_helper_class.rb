#!/usr/bin/ruby
# ruby helper class
# date: 2023.05.02 09:59:07 am

require "yaml"

class Helper 
    def initialize
        @userAgent = {
            "windows": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36",
            "linux": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.3",
            "android": "Mozilla/5.0 (Linux; Android 11; Infinix X6810 Build/RP1A.200720.011;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/102.0.5005.78 Mobile Safari/537.36"
        }
        @default_headers = {
            "User-Agent" => @userAgent[:windows]
        }
        @cli = true
    end

    def loadconfig
        if File.exist?("./rubytube.config.yml")
            return YAML.load_file(
                File.realpath(
                    "./rubytube.config.yml"
                )
            )
        else
            abort("cannot find config file: `rubytube.config.yml`!")
        end
    end

    def logger(from, message)
        if @cli
            printf(
                " \033[0m[\033[1;32m%s\033[0m] %s\n", from, message
            )
        end
    end

    def prompt(*args)
        print(*args)
           gets
    end

    def getOutput(path)
        return path ? path : File.realpath(
            File.dirname(".")
        ) + "/"
    end

    def getPage(url=nil, headers=nil, params=nil)
        begin
            return HTTParty.get(url, 
                :headers => !headers.nil? ? headers : @default_headers,
                :query => params).body
        rescue SocketError
            abort("no internet connection!")
        end
    end

    def postPage(url, headers, data)
        begin
            return HTTParty.post(
                url,
                body: data,
                headers: (!headers.nil?) ? headers : @default_headers
            ).body
        rescue SocketError
            abort("no internet connection!")
        end
    end

    def loadJson(raw)
        if (raw.instance_of?(String))
            begin
                return JSON.parse(raw)
            rescue JSON::ParserError => e
                abort(" (!) Json not valid: #{e}")
            end
        elsif (raw.instance_of?(Hash))
            return raw
        else
            abort(" (!) can't load json if type is: #{raw.class}")
        end
    end
end