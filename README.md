<div align="center">

# rubytube-downloader

![](https://img.shields.io/badge/motebaya-blue?style=flat&logo=Coursera&logoColor=white)
![](https://img.shields.io/badge/ruby-package-red?logo=ruby)
![](https://img.shields.io/github/downloads/motebaya/yshort-downloader/total.svg?style=flat&color=green&logo=GoogleChrome&logoColor=yellow)
<a href="https://www.ruby-lang.org/en/" target="_blank"> ![](https://img.shields.io/badge/installing-ruby-orange?logo=linux&logoColor=black)</a>

<sub>A ruby script that i used it for download batch video or audio from youtube playlist</sub>
</div>

### _ installing:

```
$ git clone https://github.com/motebaya/rubytube-downloader
$ cd rubytube-downloader
$ gem build
$ gem install rubytube-downloader-1.2.0.gem
$ rubytube-dl --help
```

### _ Command:
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

### _ single url
![from single](./src/demo1.gif)

### _ playlist url
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

update adding more website from <a href="https://www.y2mate.com/en560" target="_blank"> y2mate</a>
<br>

&copy; 2023 github.com/motebaya
</sub>
