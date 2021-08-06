declare -A nixenv_paths

nadd() {
    setopt local_options err_return pipefail
    for installable in "$@"; do
        out="$(nix build --json --no-link $installable | jq -r '.[].outputs[]' | head -1)"
        nixenv_paths[$installable]="$out"
        path=("$out/bin" "${path[@]}")
    done
}

nrm() {
    for installable in "$@"; do
        out="${nixenv_paths[$installable]}"
        unset "nixenv_paths[$installable]"

        index="${path[(Ie)$out/bin]}"
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
