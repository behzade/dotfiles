function orgmusic
    mkdir -p "$argv/opus"
    for filename in $argv/*;
        switch $filename
        case "*.flac"
            set trackname (basename -- "$filename" .flac)
            ffmpeg -i $filename -vn -c:a libopus -b:a 128K "$argv/opus/$trackname.ogg"
        end
    end
    beet import "$argv/opus"
end
