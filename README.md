<div align="center">

# rubytube-downloader

![](https://img.shields.io/badge/motebaya-blue?style=flat&logo=Coursera&logoColor=white)
![](https://img.shields.io/badge/ruby-package-red?logo=ruby)
![](https://img.shields.io/github/downloads/motebaya/yshort-downloader/total.svg?style=flat&color=green&logo=GoogleChrome&logoColor=yellow)
<a href="https://www.ruby-lang.org/en/" target="_blank"> ![](https://img.shields.io/badge/installing-ruby-orange?logo=linux&logoColor=black)</a>

<sub>A ruby script that i used it for download batch video or audio from youtube playlist</sub>

</div>

<sub>

- Installing

  - Install with gems

    - `gem install yshort-downloader`

  - Install from github
    - <pre><code>$ gem 'rubytube-downloader', :git => 'git://github.com/motebaya/rubytube-downloader.git'</code></pre>

- Usage as CLI (command line interface)

  - savetube
    <pre><code>usage: ./rubytube-dl -u <youtube_url> -o <output_path> -s <server> -t <type>
    example: ./rubytube-dl -u https://www.youtube.com/shorts/<shortid> -o ../media/ -s savetube -t audio
    </code></pre>

  - youtube.com
    <pre><code>usage : ./rubytube-dl -u <youtube_url> -o <output> -s <server>
    example: ./rubytube-dl -u https://www.youtube.com/shorts/<shorts_id> -o ../media/ -s youtube
    </code></pre>

  - y2mate.com
    <pre><code>usage: ./rubytube-dl -u <youtube_url> -o <output_path> -s <server>
    example: ./rubytube-dl -u https://www.youtube.com/shorts/<ytid> -o ../media/ -s y2mate
    </code></pre>

- Usage as Module:

  - savetube

    - usage: `----`

  - youtube.com

    - usage: `----`

</sub>

<sub>
- Note

- savetube limit request:

  <pre><code>&lt;!doctype html&gt;
  &lt;html lang=en&gt;
  &lt;title&gt;429 Too Many Requests&lt;/title&gt;
  &lt;h1&gt;Too Many Requests&lt;/h1&gt;
  &lt;p&gt;120 per 1 hour&lt;/p&gt;
  </code></pre>

a small update adding more website from <a href="https://www.y2mate.com/en560" target="_blank"> y2mate</a>
<br>

&copy; 2023 github.com/motebaya
</sub>
