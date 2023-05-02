#!/usr/bin/bash
# command line for bulk tested using config.
# it will read config from file `rubytube.config.yml`, you just need put an url and server

# from playlist with all server
rubytube-dl -p https://youtube.com/playlist?list=PLUPsldAdxNYdtHsTS-oEoGYvQIpZl95dM -s y2mate -c
rubytube-dl -p https://youtube.com/playlist?list=PLUPsldAdxNYdtHsTS-oEoGYvQIpZl95dM -s savetube -c
rubytube-dl -p https://youtube.com/playlist?list=PLUPsldAdxNYdtHsTS-oEoGYvQIpZl95dM -s youtube -c

# from single url with all server
rubytube-dl -u https://www.youtube.com/watch?v=lDhtkbu_E68 -s y2mate -c
rubytube-dl -u https://youtube.com/shorts/rYNFUHhi9rw?feature=share -s savetube -c
rubytube-dl -u https://www.youtube.com/watch?v=6YZlFdTIdzM -s youtube -c