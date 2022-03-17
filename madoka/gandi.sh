set -eo pipefail

ip --json addr show \
    | jq '{
            "items": [
                [ .[] | .ifname as $ifname | .addr_info[]
                    | select(
                        .scope == "global"
                        and ($ifname == "eth0"
                            or ($ifname == "wlan0"
                                and (.dynamic | not)
                                and .family == "inet6"))) ]
                | group_by(.family)[]
                | {
                    "rrset_type": { "inet": "A", "inet6": "AAAA" }[.[0].family],
                    "rrset_values": [ .[].local ],
                    "rrset_ttl": 300
                }
            ]
        }' \
    | curl -sS -X PUT -d @- \
        -H @"$CREDENTIALS_DIRECTORY/gandi_auth_header" \
        -H 'Content-Type: application/json' \
        https://api.gandi.net/v5/livedns/domains/dram.page/records/madoka \
    | jq 'if .status == "error"
            then "API Error: \(.)" | halt_error(1)
            else "Success: \(.)" | halt_error(0)
        end'
