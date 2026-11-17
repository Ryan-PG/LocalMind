
#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

RUNTIME="runtime/linux/llamafile"
MODEL="models/model.gguf" # REPLACE YOUR MODEL PATH HERE

if [ ! -f "$RUNTIME" ]; then
    echo "ERROR: Runtime not found: $RUNTIME"
    exit 1
fi

if [ ! -f "$MODEL" ]; then
    echo "ERROR: Model not found: $MODEL"
    exit 1
fi

chmod +x "$RUNTIME"

"$RUNTIME" \
    --server \
    --host 127.0.0.1 \
    --port 8080 \
    --gpu auto \
    -m "$MODEL" \
    -ngl 999
