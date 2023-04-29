<div align="center">

  # rubytube-downloader

![](https://img.shields.io/badge/motebaya-blue?style=flat&logo=Coursera&logoColor=white)
![](https://img.shields.io/badge/ruby-package-red?logo=ruby)
![](https://img.shields.io/github/downloads/motebaya/yshort-downloader/total.svg?style=flat&color=green&logo=GoogleChrome&logoColor=yellow)
<a href="https://www.ruby-lang.org/en/" target="_blank"> ![](https://img.shields.io/badge/installing-ruby-orange?logo=linux&logoColor=black)</a>

  <sub>A ruby script that i used it for download batch video or audio from youtube playlist</sub>
</div>


<details>
  <summary> Installing With Gem </summary>

```bash
  * Install with gems
    > gem install yshort-downloader
  * Install from github
    > gem 'rubytube-downloader', :git => 'git://github.com/motebaya/rubytube-downloader.git'
```

</details>

<details>
  <summary>Usage as CLI (command line interface)</summary>

- savetube

```bash
  usage: ./rubytube-dl -u <youtube_url> -o <output_path> -s <server> -t <type>

  example: ./rubytube-dl -u https://www.youtube.com/shorts/<shortid> -o ../media/ -s savetube -t audio

```

- youtube.com

```
usage : ./rubytube-dl -u <youtube_url> -o <output> -s <server>

example: ./rubytube-dl -u https://www.youtube.com/shorts/<shorts_id> -o ../media/ -s youtube

```

- y2mate.com

```
usage: ./rubytube-dl -u <youtube_url> -o <output_path> -s <server>

example: ./rubytube-dl -u https://www.youtube.com/shorts/<ytid> -o ../media/ -s y2mate
```

</details>

<details>
<summary> Usage as Module:</summary>

- savetube

```bash
usage: --
```

- youtube.com

```
usage: --
```

</details>

  
- Note

<span> savetube limit request: <pre><code>&lt;!doctype html&gt;
  &lt;html lang=en&gt;
  &lt;title&gt;429 Too Many Requests&lt;/title&gt;
  &lt;h1&gt;Too Many Requests&lt;/h1&gt;
  &lt;p&gt;120 per 1 hour&lt;/p&gt;
</code></pre></span>

<sub> a small update adding more website from <a href="https://www.y2mate.com/en560" target="_blank"> y2mate</a> </sub>
<br>
<sub> &copy; 2023 github.com/motebaya </sub>

