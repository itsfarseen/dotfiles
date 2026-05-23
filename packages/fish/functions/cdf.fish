function cdf
    if test (count $argv) -eq 0
        set -l dir (fzf --walker dir,hidden --scheme path)
        and cd $dir
    else
        set -l result (find . -iname "*$argv*" 2>/dev/null | fzf --select-1 --exit-0)
        or return 1
        if test -d "$result"
            cd $result
        else
            cd (dirname $result)
        end
    end
end
