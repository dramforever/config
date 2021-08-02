declare -A nixenv_paths

nadd() {
    setopt local_options err_return pipefail
    for installable in "$@"; do
        out="$(nix build --json --no-link $installable | jq -r '.[].outputs[]' | head -1)"
        nixenv_paths[$installable]="$out"
        path+=("$out/bin")
    done
}

nrm() {
    for installable in "$@"; do
        out="${nixenv_paths[$installable]}"
        nixenv_paths[$installable]=""
        [[ -z "$out" ]] && continue

        index="${path[(Ie)$out/bin]}"
        [[ $index -eq 0 ]] && continue

        path[$index]=()
    done
}

nls() {
    for installable out in "${(@kv)nixenv_paths}"; do
        [[ -z "$out" ]] || echo "$installable -> $out"
    done
}

_nadd() {
    words[1]=(nix build)
    CURRENT+=1
    _nix
}

compdef _nadd nadd

_nrm() {
    keys=()
    for installable in "${(@k)nixenv_paths}"; do
        [[ -z "${nixenv_paths[$installable]}" ]] || keys+=("$installable")
    done
    _values 'nrm' "${(@)keys}"
}

compdef _nrm nrm