#!/usr/bin/ruby
# playlist class handle
# update: 10:06:09 am, 2023.05.02
# @github.com/motebaya

class Playlist < Helper
    
    def initialize(
        playlist=nil,
        path=nil,
        server=nil,
        type=nil,
        default_quality=nil
    )
        super()
        @cli = true
        @default_quality = default_quality
        @formats = type
        @server = server
        @path = getOutput(path)
        @playlist_url = playlist
        @youtube_url = "https://www.youtube.com/watch?v=%s"
        @regex_playlist = %r"^http[s]:\/\/(?:youtu\.be\/|(?:www\.|m\.)?youtube\.com\/(?:playlist|list|embed)(?:\.php)?(?:\?list=|\/))(?<id>[a-zA-Z0-9\-_]+)"
    end

    def extract
        # get all youtube id from JS source
        if (playlistid = @playlist_url.match(@regex_playlist))
            logger("playlist", "downloading webpage: #{playlistid[:id]}")
            webpage = getPage(@playlist_url)
            if (video_list = webpage.scan(/"videoId":"(.*?)"/).uniq)
                logger("playlist", "found #{video_list.length} video in playlist.")
                video_list.each_with_index do | val, index |
                    # execute call func 
                    logger("playlist","processing #{val[0]} #{index+1} of #{video_list.length}")
                    case @server
                    when "y2mate"
                        Y2mate.new(
                            url=@youtube_url % val,
                            path=@path,
                            cli=true,
                            default_quality=@default_quality
                        ).extract()

                    when "savetube"
                        SaveTube.new(
                            url=@youtube_url % val,
                            formats=@formats,
                            path=@path,
                            cli=true,
                            default_quality=@default_quality
                        ).extract()
                    when "youtube"
                        YoutubeCom.new(
                            url=@youtube_url % val, 
                            path=@path,
                            cli=true,
                            default_quality=@default_quality
                        ).extract()
                    end
                end
            end
        end
    end
end
