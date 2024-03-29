<div align="center">

# rubytube-downloader

![](https://img.shields.io/badge/motebaya-blue?style=flat&logo=Coursera&logoColor=white)
![](https://img.shields.io/badge/ruby-package-red?logo=ruby)
![](https://img.shields.io/github/downloads/motebaya/yshort-downloader/total.svg?style=flat&color=green&logo=GoogleChrome&logoColor=yellow)
<a href="https://www.ruby-lang.org/en/" target="_blank"> ![](https://img.shields.io/badge/installing-ruby-orange?logo=linux&logoColor=black)</a>

<sub>A ruby script that i used it for download batch video or audio from youtube playlist</sub>

</div>

### \_ installing:

```
$ git clone https://github.com/motebaya/rubytube-downloader
$ cd rubytube-downloader
$ gem build
$ gem install rubytube-downloader-1.2.0.gem
$ rubytube-dl --help
```

### \_ run on local server

- using `shotgun` for `development` or directly run with `ruby` for `production`

```
$ gem install shotgun -v 0.9.2
$ gem install sinatra -v 3.0.6
$ gem install puma -v 4.3.8
$ shotgun index.rb
== Shotgun/Puma on http://127.0.0.1:9393/
Puma starting in single mode...
* Version 4.3.8 (ruby 3.1.4-p223), codename: Mysterious Traveller
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://127.0.0.1:9393
Use Ctrl-C to stop
```

![screenshot](./src/screenshot.png)

### \_ CLI Command:

```
            ┬─┐┬ ┬┌┐ ┬ ┬┌┬┐┬ ┬┌┐ ┌─┐ ┌┬┐┬
            ├┬┘│ │├┴┐└┬┘ │ │ │├┴┐├┤───│││
            ┴└─└─┘└─┘ ┴  ┴ └─┘└─┘└─┘ ─┴┘┴─┘
      ~ a ruby script for DL batch youtube video ~
          ~ © https://github.com/motebaya ~

    Usage: rubytube-dl [OPTIONS]
        -u, --url url                    youtube video/shorts url
        -o, --output output              output path download e.g: '/home/username/'
        -s, --server server              select server, server list: [ youtube, savetube, y2mate ]
        -t, --type type                  type of media: audio (.mp3) or video (.mp4)
        -c, --config                     using config from: 'config.yml'
        -p, --playlist playlist          youtube playlist url
        -h, --help                       show help and exit.
```

### \_ single url

![from single](./src/demo1.gif)

### \_ playlist url

![from playlist](./src/demo2.gif)

<sub>
- Note

- savetube limit request:

  <pre><code>&lt;!doctype html&gt;
  &lt;html lang=en&gt;
  &lt;title&gt;429 Too Many Requests&lt;/title&gt;
  &lt;h1&gt;Too Many Requests&lt;/h1&gt;
  &lt;p&gt;120 per 1 hour&lt;/p&gt;
  </code></pre>

- youtube [signature authorization](https://github.com/ytdl-org/youtube-dl/blob/211cbfd5d46025a8e4d8f9f3d424aaada4698974/youtube_dl/extractor/youtube.py#L1574) issue:

  ```
  "signatureCipher":"s=_%3DUVUYL4RQgaW7wZtZMBwYK199-NuGB9GFGcDD%3DmdxyTzAEiAgfRlI2ag5SFdxPkA1qFxBLvDNDgzegohCUWxdDTTAGKAhIgRw8JQ0qOAqOAqOO\u0026sp=sig\u0026url=https://rr4---sn-uxa3vhnxa-nvje.googlevideo.com/videoplayback%3Fexpire%3D1683329429%26ei%3DNT1VZLmACIuJg8UPr8mu-Ac%26ip%3D182.2.39.127%26id%3Do......_5qg%253D%253D"
  ```

update adding more website from <a href="https://www.y2mate.com/en560" target="_blank"> y2mate</a>
<br>

&copy; 2023 github.com/motebaya
</sub>
