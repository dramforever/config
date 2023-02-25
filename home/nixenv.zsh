declare -A nixenv_paths

nadd() {
    setopt local_options err_return pipefail
    local out out_paths
    for installable in "$@"; do
        local with_outputs="$installable^*"
        if [[ "$installable" = *"^"* ]]; then
            with_outputs="$installable"
        fi

        local out=""
        out=(${(@f)"$(nix build --json --no-link $with_outputs | jq --raw-output '.[].outputs[]')"})

        local out_paths=(${^out}/bin)
        local added_paths=()

        for p in "${out_paths[@]}"; do
            if (($path[(Ie)$p] == 0)); then
                added_paths+=("$p")
            fi
        done

        if (("${#added_paths[@]}" == 0)); then
            echo "$installable: Already added" >&2
        else
            nixenv_paths[$installable]="${(j/:/)added_paths}"
            path=("${added_paths[@]}" "${path[@]}")
        fi
    done
}

nrm() {
    for installable in "$@"; do
        local added_paths="${nixenv_paths[$installable]}"
        unset "nixenv_paths[$installable]"

        for p in "${(@s/:/)added_paths}"; do
            index="${path[(Ie)$p]}"
            (( $index != 0 )) && path[$index]=()
        done
    done
}

nls() {
    for installable added_paths in "${(@kv)nixenv_paths}"; do
        echo "$installable:"

        for p in "${(@s/:/)added_paths}"; do
            if [[ -d $p ]]; then
                echo "  $p"
                echo "    ${(@f)"$(ls --color=always $p)"}"
            fi
        done
    done
}

_nadd() {
    words[1]=(nix build)
    CURRENT+=1
    _nix
}

compdef _nadd nadd

_nrm() {
    local keys=(${(@k)nixenv_paths})

    for i in {2..${#words}}; do
        if (($i == $CURRENT)); then
            continue
        fi
        local remove="${words[$i]}"
        local index="${keys[(Ie)$remove]}"
        (( $index != 0 )) && keys[$index]=()
    done

    if ((${#keys[@]})); then
        _values 'nrm' "${keys[@]}"
    fi
}

compdef _nrm nrm
