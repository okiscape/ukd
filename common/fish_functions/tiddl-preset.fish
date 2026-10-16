function tiddl-preset --wraps='tiddl download -q max -o {album.artist}/{album.title}/{item.volume}.{item.number:02d}. {item.title} -p $HOME/Music/ url' --wraps='tiddl download -q max -o "{album.artist}/{album.title}/{item.volume}.{item.number:02d}. {item.title}" -p $HOME/Music/ url'
    tiddl download -q max -o "{album.artist}/{album.title}/{item.volume}.{item.number:02d}. {item.title}" -p $HOME/Music/ url $argv
end
