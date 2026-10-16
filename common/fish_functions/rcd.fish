function cd
    if test (count $argv) -gt 0
        builtin cd $argv
    else
        builtin cd ~
    end

    if test $status -eq 0
        set --universal _last_cd_dir (pwd)
    end
end

function rcd
    if set -q _last_cd_dir
        cd $_last_cd_dir
    else
        echo "rcd: no recent dir saved yet"
    end
end
