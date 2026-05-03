# Hello world tests

The repeatable test cases below use the wrapper script at `./scripts/test-hello-word`.

## github-copilot/oswe-vscode-prime

```bash
./scripts/test-hello-word github-copilot oswe-vscode-prime
```

## github-copilot/gpt-5-mini

```bash
./scripts/test-hello-word github-copilot gpt-5-mini
```

## openrouter/qwen/qwen3.6-plus:free

```bash
./scripts/test-hello-word openrouter "qwen/qwen3.6-plus:free"
```

## xai/grok-4-1-fast-non-reasoning

```bash
./scripts/test-hello-word xai grok-4-1-fast-non-reasoning
```

## ollama-cloud/gpt-oss:120b-cloud

```bash
./scripts/test-hello-word ollama-cloud "gpt-oss:120b-cloud"
```

## Raw curl example

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
