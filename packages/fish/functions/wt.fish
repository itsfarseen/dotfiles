function wt --description 'Git worktree manager'
    set -l tmpfile /tmp/wt_cd_$fish_pid
    __FISH_WRAPPER_CD_OUTPUT=$tmpfile command wt $argv
    set -l code $status
    if test -f $tmpfile
        cd (cat $tmpfile)
        rm -f $tmpfile
    end
    return $code
end
