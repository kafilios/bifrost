#!/bin/bash

GITHUB_TOKEN=$(op read op://x3mqvkweewpkgfwmsifle4vdtu/gv2uk26o6vlttxdgjjmqfl3jmq/password)

curl -s 'https://api.githubcopilot.com/models' \
-H "authorization: Bearer $GITHUB_TOKEN" \
-H 'Copilot-Integration-Id: vscode-chat' | jq -r '.data[].id' | sort
