# Hello world tests

## github-copilot/oswe-vscode-prime

```bash
curl https://bifrost.tail39d2.ts.net/v1/chat/completions \
--header 'Content-Type: application/json' \
--data '{
    "model": "github-copilot/oswe-vscode-prime",
    "messages": [
        {"role": "user", "content": "Hello!"}
    ]
}'
```

## github-copilot/gpt-5-mini

```bash
curl https://bifrost.tail39d2.ts.net/v1/chat/completions \
--header 'Content-Type: application/json' \
--data '{
    "model": "github-copilot/gpt-5-mini",
    "messages": [
        {"role": "user", "content": "Hello!"}
    ]
}'

```
## openrouter/qwen/qwen3.6-plus:free

```bash
curl https://bifrost.tail39d2.ts.net/v1/chat/completions \
--header 'Content-Type: application/json' \
--data '{
    "model": "openrouter/qwen/qwen3.6-plus:free",
    "messages": [
        {"role": "user", "content": "Hello!"}
    ]
}'
```