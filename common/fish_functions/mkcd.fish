function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <dir>"
        return 1
    end
    mkdir -p $argv
    cd $argv
end
