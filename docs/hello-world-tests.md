# Hello world tests

The repeatable test cases below use the wrapper script at `./scripts/test-hello-word`.

## openrouter

```bash
# qwen/qwen3-coder:free
./scripts/test-hello-word openrouter "qwen/qwen3-coder:free"
```

## xai

Model listing: https://console.x.ai/team/2c415005-8b4b-4629-abdf-fa839a8e4562/models

```bash
# grok-4.3
./scripts/test-hello-word xai grok-4.3

# grok-build-0.1
./scripts/test-hello-word xai grok-build-0.1
```

## deepseek

Model listing: https://api-docs.deepseek.com/quick_start/pricing/

```bash
# deepseek-v4-flash
./scripts/test-hello-word deepseek deepseek-v4-flash

# deepseek-v4-pro
./scripts/test-hello-word deepseek deepseek-v4-pro
```

## minimax

Model listing: https://platform.minimax.io/docs/guides/models-intro

```bash
# minimax-m3
./scripts/test-hello-word minimax minimax-m3

# minimax-m2.7
./scripts/test-hello-word minimax minimax-m2.7
```

## ollama-cloud

```bash
# gpt-oss:120b-cloud
./scripts/test-hello-word ollama-cloud "gpt-oss:120b-cloud"
```

## nvidia

Model listing: https://build.nvidia.com/models?filters=nimType%3Anim_type_preview

```bash
# minimaxai/minimax-m2.7
./scripts/test-hello-word nvidia "minimaxai/minimax-m2.7"

# z-ai/glm4.7
./scripts/test-hello-word nvidia "z-ai/glm4.7"

# qwen/qwen3-coder-480b-a35b-instruct
./scripts/test-hello-word nvidia "qwen/qwen3-coder-480b-a35b-instruct"
```

## Raw curl example

```bash
curl https://bifrost.tail39d2.ts.net/v1/chat/completions \
--header 'Content-Type: application/json' \
--data '{
    "model": "nvidia/minimaxai/minimax-m2.7",
    "messages": [
        {"role": "user", "content": "Hello!"}
    ]
}'
```
