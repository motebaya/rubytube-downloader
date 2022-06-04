<p align="center">
<img src="https://i.ibb.co/ZYjZwgd/1654340956599.png"/>
<a href="https://github.com/valsztrax" target="_blank"><img style="width: 50%; display: block; margin-right: auto; margin-left:auto" src="https://img.shields.io/badge/Author-valsztrax-yellow?style=flat&logo=Coursera&logoColor=white"/></a>
</p>

![](https://img.shields.io/badge/ruby-package-red?logo=ruby)
![visitor badge](https://visitor-badge.glitch.me/badge?page_id=yshort-downloader&left_text=Total%20views)
![](https://img.shields.io/github/downloads/valsztrax/yshort-downloader/total.svg?style=flat&color=green&logo=GoogleChrome&logoColor=white)
<a href="https://mobile.twitter.com/valzshel" target="_blank"> ![](https://img.shields.io/badge/Twitter-@valszhel-blue?logo=twitter)</a>
<a href="https://www.ruby-lang.org/en/" target="_blank"> ![](https://img.shields.io/badge/installing-ruby-orange?logo=linux&logoColor=black)</a>

#### installing package
```bash
  * Install with gems
    > gem install yshort-downloader
  * Install from github
    > gem 'yshort-downloader', :git => 'git://github.com/valsztrax/yshort-downlaoder.git'
```

### use as module
 * importing
```ruby
irb(main):002:0> require "yshorts_downloader"
irb(main):005:0> short = YoutubeShort.new("https://youtube.com
/shorts/<shorts_id>?feature")
```

* Get json data
```ruby
irb(main):019:0> js_data = short.parseJS(short.getPage(short.shorts_
url)) =>
# result:
{
"author"=>"<shorts_author>",
 "title"=>"<shorts_title>",
 "duration"=>"<shorts_duration>",
 "tags"=> "<shorts_tags>" # nil if nothing tags
 "description"=> "<shorts_description>"
}
```

* running to download
```ruby
irb(main):000:0> short.Main()
```

* Audio with video
```ruby
irb(main):022:0> short.formats
=>
[{
    "link"=> "https://rr3---sn-uxa3vhnxa-nvjl.googlevideo.com/.....",
    "type"=>"video/mp4",
    "quality"=>"360p",
    "bitrate"=>598208
},  "{....}"]
```

* Just fomat only ,eg: .webm, .mp4
```ruby
irb(main):022:0> short.adaptiveFormats
=>
[{
    "link"=> "https://rr3---sn-uxa3vhnxa-nvjl.googlevideo.com/.....",
    "type"=>"video/mp4",
    "quality"=>"1080p",
    "bitrate"=> 1954462
},  "{....}"]
```

### CLI Command
```bash
            ╦ ╦┌─┐┬ ┬┌─┐┬─┐┌┬┐╦═╗┌┐
            ╚╦╝└─┐├─┤│ │├┬┘ │ ╠╦╝├┴┐
             ╩ └─┘┴ ┴└─┘┴└─ ┴o╩╚═└─┘
   [ a simple ruby youtube short downloader ]
           [ github.com/valsztrax ]

 Usage: yshort.rb [options] / -h
    -u, --url url                    url youtube short
    -o, --output output              output path download
    -h, --help                       show all options and exit
````
 * User cli command
```
yshort-dl -u <shorts_url> -o <path_to_save>
# default output is where you run the command.
```

** Me also in twitter ***
* [@valzshel](https://mobile.twitter.com/valzshel)
