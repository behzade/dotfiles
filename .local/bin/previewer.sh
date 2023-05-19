#!/usr/bin/env bash

TMP_FILE="$HOME/.cache/lf/err.png"

function check_cache {
    if [ ! -d "$HOME/.cache/lf" ]; then
	mkdir -p "$HOME/.cache/lf"
    fi
}

function hash_filename {
    TMP_FILE="$HOME/.cache/lf/$(echo ${1%.*} | sed -e 's|/|\!|g').$2"
}

function draw_image {
    a=$(($2-1))
    kitty +kitten icat --transfer-mode file --stdin no --place "${a}x$3@$4x$5" --scale-up "$1" < /dev/null > /dev/tty
}

function make_video {
    if [ "${TMP_FILE}" -ot "$1" ]; then
	ffmpegthumbnailer -t 50% -q 3 -s 0 \
			  -c jpeg -i "$1" -o "${TMP_FILE}"
    fi
}

function make_pdf {
    if [ "${TMP_FILE}" -ot "$1" ]; then
	pdftoppm -png -f 1 -l 1 -jpeg -tiffcompression jpeg \
		 -scale-to-x -1 -scale-to-y 768 \
		 -singlefile "$1" "${TMP_FILE%.png}"
    fi
}

function make_epub {
    if [ "${TMP_FILE}" -ot "$1" ]; then
        gnome-epub-thumbnailer -s 768 "$1" "$TMP_FILE"
    fi
}

check_cache
case $(file -b --mime-type "$1") in
    text/*|application/json|application/xml|application/x-extension-html)
    bat --color=always --style=plain --pager=never "$1"
	;;
    image/*)
	draw_image "$1" "$2" "$3" "$4" "$5"
	exit 1
	;;
    video/*)
	hash_filename "$1" "jpg"
	make_video "$1" "$2" "$3"
	draw_image "${TMP_FILE}" "$2" "$3" "$4" "$5"
	exit 1
	;;
    audio/*)
    exiftool "$1"
    ;;
    application/pdf)
	hash_filename "$1" "png"
	make_pdf "$1" "$2" "$3"
	draw_image "${TMP_FILE}" "$2" "$3" "$4" "$5"
	exit 1
    ;;
    application/epub+zip)
	hash_filename "$1" "png"
	make_epub "$1" "$2" "$3"
	draw_image "${TMP_FILE}" "$2" "$3" "$4" "$5"
	exit 1
	;;
    application/msword)
    catdoc "$1"
    ;;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document)
    doc2txt "$1" -
    ;;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
    ssconvert --export-type=Gnumeric_stf:stf_csv "$1" "fd://1" | bat --language=csv
    ;;
    application/x-iso9660-image)
    iso-info --no-header -l "$1"
    ;;
    application/gzip|application/x-xz)
	tar tf "$1"
	;;
    application/zip)
	unzip -Z -1 "$1"
	;;
    application/x-sharedlib)
	readelf -h "$1"
	;;
    *)
    bat "$1"
    ;;
esac

exit 0
