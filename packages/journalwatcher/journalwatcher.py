#!/usr/bin/env python3
import json
import os
import pathlib
import subprocess
import sys

xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR")

assert xdg_runtime_dir

start_at_path = pathlib.Path(xdg_runtime_dir) / "journalwatch-timestamp"

# Create if not already there
start_at_path.touch(mode=0o600)

try:
    start_at = int(start_at_path.read_text())
except ValueError:
    start_at = None

more_args = []

if start_at is None:
    more_args.append("--since=now")

journal = subprocess.Popen(
    [
        "journalctl",
        "--priority=warning",
        "--follow",
        "--output=json",
        "--boot",
        *more_args,
    ],
    encoding="utf-8",
    errors="replace",
    stdout=subprocess.PIPE,
)

bucket, bucket_thresh, bucket_max = 0.0, 3.0, 10.0
cur_time = None


def notify(summary: str, message: str):
    try:
        subprocess.run(
            [
                "notify-send",
                "--urgency=critical",
                "--app-name=Journal",
                summary,
                message,
            ],
            check=True,
        )
    except subprocess.CalledProcessError as e:
        print(e, file=sys.stderr)


assert journal.stdout is not None

for line in journal.stdout:
    data = json.loads(line)
    if "__MONOTONIC_TIMESTAMP" not in data:
        continue
    try:
        monotonic: int = int(data["__MONOTONIC_TIMESTAMP"])
    except ValueError:
        continue

    prio = data.get("PRIORITY", "9")
    if data.get("SYSLOG_FACILITY", None) == "0":
        # Kernel
        max_prio = 4
    else:
        max_prio = 3

    try:
        if int(prio) > max_prio:
            continue
    except ValueError:
        continue

    if start_at is not None and monotonic <= start_at:
        continue

    prev_bucket = bucket
    bucket = min(bucket + 1.0, bucket_max)

    if cur_time is None or cur_time < monotonic:
        if cur_time is not None:
            bucket = max(0.0, bucket - (monotonic - cur_time) / 1e6)

        cur_time = monotonic
        start_at_path.write_text(str(monotonic))

    if prev_bucket < bucket_thresh and bucket >= bucket_thresh:
        notify("Too many errors", "More messages suppressed")

    ident: str | None = data.get("SYSLOG_IDENTIFIER", data.get("_COMM", None))
    message: str | None = data.get("MESSAGE", None)

    if bucket < bucket_thresh:
        LIMIT = 100
        summary = ident[:LIMIT] if ident is not None else "Error"
        if message:
            suffix = "..." if len(message) > LIMIT else ""
            show_message = message[:LIMIT] + suffix
        else:
            show_message = "(Error without message)"
        notify(summary, show_message)
