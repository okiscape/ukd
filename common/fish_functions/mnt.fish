function mnt --wraps=mount --wraps='sudo mount' --description 'alias mnt=sudo mount'
    sudo mount $argv
end
