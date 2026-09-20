#!/usr/bin/env bash
# Shared helpers for postAttachCommand scripts.

log() { echo "postAttachCommand: [$1] ${*:2}" >&2; }
