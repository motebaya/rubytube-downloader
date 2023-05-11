#!/usr/bin/ruby
# ruby API implement with sinatra/shotgun/puma
# date: wed 05.03.2023 - 02:33:31
# Copyright 2023 Motebaya a.k.a Michino

require 'sinatra'

# load class from lib
Dir["./lib/*_class.rb"].each do | modules |
    if !File.basename(
        modules
    ).start_with?("downloader")
        require_relative modules
    end
end

# check youtube url
def check_url(url)
    return url.match(
        %r"^(?:http(?:s)?:\/\/)?(?:www\.)?(?:m\.)?(?:youtu\.be\/|youtube\.com\/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user|shorts)\/))([^\?&\"'>]+)")
    end

# API response msg
def showMessage(msg)
    content_type :json
    return JSON.pretty_generate(
        msg,indent: '    '
    )
end

# set public folder
configure do 
    set :public_folder, File.expand_path('../public', __FILE__)
end

# handle 404/ page not found
not_found do
    status 404
    showMessage({
        error: 'bing chiling!'
    })
end

# don't store the cache
before do
  cache_control :no_cache, :no_store, :must_revalidate
end

# API route
get %r{/(y2mate|savetube|youtube)} do
    routename = request.path_info.gsub("/", "")
    response = {"success": true}
    if params.key?("url")
        youtubeUrl = params['url']
        if !youtubeUrl.nil?
            youtubeID = check_url(youtubeUrl)
            if !youtubeID.nil?
                youtubeID = youtubeID[1]
                case routename
                when "youtube"
                    data = YoutubeCom.new(
                        youtubeUrl
                    ).analyze
                    response.merge!(data)
                    showMessage(response)
                when "y2mate"
                    main = Y2mate.new(
                        youtubeUrl
                    )
                    response.merge!(main.analyze)
                    showMessage(response)
                when "savetube"
                    type = params.key?("f") ? params['f'] : 'video'
                    main = SaveTube.new(
                        youtubeUrl, type
                    )
                    response.merge!(main.analyze)
                    showMessage(response)
                else
                    showMessage({
                        error: 'invalid methods!', 
                        message: 'docs: @github.com/motebaya/rubytube-downloader'
                    })
                end
            else
                showMessage({
                    error: 'invalid youtube url!'
                })
            end
        else
            showMessage({
                error: 'invalid params!',
                message: 'docs: @github.com/motebaya/rubytube-downloader'
            })
        end
    elsif (params.key?("t") && params.key?("d"))
        token = params['t'] # for y2mate as token and same with savetube
        data = params['d'] # for y2mate as ytid and for savetube is quality
        if routename == "y2mate"
            converted = Y2mate.new.convert(data, token)
            response.merge!(
                JSON.parse(
                    converted
                )
            )
            showMessage(response)
        elsif routename == "savetube"
            # quality = formats
            quality = ["1920","1280","854","640","426","256", "144"].include?(data) ? "video" : "audio"
            converted = SaveTube.new.extract(quality, data, token)
            response.merge!(
                JSON.parse(converted)
            )
            showMessage(response)
        end
    else
        showMessage({
            error: 'visit @github.com/motebaya/rubytube-dowloader'
        })
    end
end

get "/" do 
    erb :index
end