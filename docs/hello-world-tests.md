# Hello world tests

The repeatable test cases below use the wrapper script at `./scripts/test-hello-word`.

## github-copilot

### oswe-vscode-prime

```bash
./scripts/test-hello-word github-copilot oswe-vscode-prime
```

### gpt-5-mini

```bash
./scripts/test-hello-word github-copilot gpt-5-mini
```

## openrouter

### qwen/qwen3.6-plus:free

```bash
./scripts/test-hello-word openrouter "qwen/qwen3.6-plus:free"
```

## xai

### grok-4-1-fast-non-reasoning

```bash
./scripts/test-hello-word xai grok-4-1-fast-non-reasoning
```

## ollama-cloud

### gpt-oss:120b-cloud

```bash
./scripts/test-hello-word ollama-cloud "gpt-oss:120b-cloud"
```

## nvidia

Model listing: https://build.nvidia.com/models?filters=nimType%3Anim_type_preview

### minimaxai/minimax-m2.7

```bash
./scripts/test-hello-word nvidia minimaxai/minimax-m2.7
```

### z-ai/glm4.7

```bash
./scripts/test-hello-word nvidia "z-ai/glm4.7"
```

### qwen/qwen3-coder-480b-a35b-instruct

```bash
./scripts/test-hello-word nvidia "qwen/qwen3-coder-480b-a35b-instruct"
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
