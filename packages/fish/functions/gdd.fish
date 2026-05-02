function gdd
    set -l ref (test (count $argv) -gt 0; and echo $argv[1]; or echo HEAD)
    git diff $ref^ $ref
end
