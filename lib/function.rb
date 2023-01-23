#!/usr/bin/ruby
# -- function helper list --

require "httparty"
require "json"

def prompt(*args)
    print(*args)
       gets
end

def getPage(url=nil, headers=nil, params=nil)
    default_headers = {'user-agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36'}
    begin
        return HTTParty.get(url, 
            :headers => !headers.nil? ? headers : default_headers,
            :query => params).body
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
