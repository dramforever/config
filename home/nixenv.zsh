declare -A nixenv_paths

nadd() {
    setopt local_options err_return pipefail
    local out out_paths
    for installable in "$@"; do
        local out=(${(@f)"$(nix build --json --no-link $installable | jq -r '.[].outputs[]')"})
        local out_paths=(${^out}/bin)
        local joined_paths="${(j/:/)out_paths}"
        if (($path[(Ie)$joined_paths])); then
            echo $installable already added
        else
            nixenv_paths[$installable]="$joined_paths"
            path=("$joined_paths" "${path[@]}")
        fi
    done
}

nrm() {
    for installable in "$@"; do
        local out="${nixenv_paths[$installable]}"
        unset "nixenv_paths[$installable]"

        index="${path[(Ie)$out]}"
        [[ $index -eq 0 ]] && continue

        path[$index]=()
    done
}

nls() {
    for installable out in "${(@kv)nixenv_paths}"; do
        echo "$installable -> $out"
    done
}

_nadd() {
    words[1]=(nix build)
    CURRENT+=1
    _nix
}

compdef _nadd nadd

_nrm() {
    _values 'nrm' "${(@k)nixenv_paths}"
}

compdef _nrm nrm
