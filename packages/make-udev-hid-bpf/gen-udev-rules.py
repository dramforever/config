import argparse
import json
import sys

if __name__ == '__main__':
    parser = argparse.ArgumentParser(usage='udev-hid-bpf inspect BPFDIR/*.bpf.o | python3 gen-udev-rule.py --bpfdir BPFDIR --helper PATH_TO_udev-hid-bpf > 90-hid-bpf-NAME.rules')
    parser.add_argument('--bpfdir', required=True, help='Directories for .bpf.o files')
    parser.add_argument('--helper', required=True, help='Path to udev-hid-bpf')
    args = parser.parse_args()
    data = json.load(sys.stdin)
    print('ACTION!="add|remove", GOTO="hid_bpf_end"')
    print('SUBSYSTEM!="hid", GOTO="hid_bpf_end"')
    print()

    for f in data:
        filename = f['filename']
        print(f'# {filename}')
        for d in f['devices']:
            bus, group, vid, pid = d['bus'], d['group'], d['vid'], d['pid']

            def fmt(x: str):
                num = int(x, 0)
                if num:
                    return f'{num:04X}'
                else:
                    # Match any
                    return '*'

            modalias = f'hid:b{fmt(bus)}g{fmt(group)}v0000{fmt(vid)}p0000{fmt(pid)}'
            print(f'ACTION=="add",ENV{{MODALIAS}}=="{modalias}", RUN{{program}}+="{args.helper} add $sys$devpath - {args.bpfdir}/{filename}"')
            print(f'ACTION=="remove",ENV{{MODALIAS}}=="{modalias}", RUN{{program}}+="{args.helper} remove $sys$devpath"')
        print()
    print('LABEL="hid_bpf_end"')
