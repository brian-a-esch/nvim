#!/bin/bash

# TODO figure out what defrag-thold (KV cache defragmentation threshold) does
llama-server \
  --model ~/.models/ggml-org_Qwen2.5-Coder-1.5B-Q8_0-GGUF_qwen2.5-coder-1.5b-q8_0.gguf \
  --port 8012 \
  --n-gpu-layers 99 \
  --flash-attn \
  --defrag-thold 0.1 \
  --ubatch-size 512 \
  --batch-size 1024 \
  --ctx-size 0 \
  --cache-reuse 256
