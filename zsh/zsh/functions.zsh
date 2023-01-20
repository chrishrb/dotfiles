#!/bin/zsh

vim-light () { # {{{
    nvim --cmd "let g:tokyonight_style = 'day'" ${1}
}
# # }}}
## {{{ youtube-dl
dl-music() {
  youtube-dl \
    --ignore-errors \
    --format bestaudio \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 360K \
    --restrict-filenames \
    --embed-thumbnail \
    --add-metadata \
    --output "~/Music/youtube/%(title)s.%(ext)s" $1
}

dl-video() {
  youtube-dl \
    --ignore-errors \
    --format bestaudio \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 360K \
    --restrict-filenames \
    --embed-thumbnail \
    --add-metadata \
    --output "~/Video/youtube/%(title)s.%(ext)s" $1
}

## }}}
## {{{ extract method
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS
## }}}
# {{{ Create tar
function make_tar {
  tar -czvf "$@"
}
# }}}
  # Timetrap extension {{{
  t () {
    if [[ $1 == "lastweek" ]]; then
      t week all -s $(gdate -d "1 week ago" +%F)
    else
      timetrap "$@"
    fi
  }
  # }}}
