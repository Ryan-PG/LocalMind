
#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

RUNTIME_DIR="runtime/linux"
MODEL_DIR="models"

echo
echo "================================="
echo "            LocalMind"
echo "================================="
echo

# Find the first executable runtime containing "llama" in its filename
RUNTIME=""

for file in "$RUNTIME_DIR"/*llama*; do
    if [[ -f "$file" && -x "$file" ]]; then
        RUNTIME="$file"
        break
    fi
done

if [[ -z "$RUNTIME" ]]; then
    echo "ERROR: No executable llama runtime found in $RUNTIME_DIR"
    exit 1
fi

# Find GGUF models only
shopt -s nullglob
MODELS=("$MODEL_DIR"/*.gguf)

if [[ ${#MODELS[@]} -eq 0 ]]; then
    echo "ERROR: No GGUF models found in $MODEL_DIR"
    exit 1
fi

echo "Runtime: $RUNTIME"
echo
echo "Available models:"
echo

for i in "${!MODELS[@]}"; do
    printf "[%d] %s\n" "$((i + 1))" "$(basename "${MODELS[$i]}")"
done

echo
read -rp "Select a model: " CHOICE

# Validate selection
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] ||
   (( CHOICE < 1 || CHOICE > ${#MODELS[@]} )); then
    echo
    echo "ERROR: Invalid selection."
    exit 1
fi

MODEL="${MODELS[$((CHOICE - 1))]}"

echo
echo "Selected model: $(basename "$MODEL")"
echo "Starting LocalMind..."
echo

"$RUNTIME" \
    --server \
    --host 127.0.0.1 \
    --port 8080 \
    --gpu auto \
    -m "$MODEL" \
    -ngl 999
