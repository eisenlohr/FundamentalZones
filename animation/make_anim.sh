#!/bin/bash

# Requirements: ImageMagick v7+, bash
# Usage: ./make_clean_gif.sh input_prefix output.gif [delay]

# Inputs
INPUT_PREFIX="${1:-frame_}"         # default: frame_001.png, etc.
OUTPUT_NAME="${2:-spin.gif}"        # default output filename
DELAY="${3:-5}"                     # default: 5 = 20 fps

# Step 1: Clean background
echo "Removing white background..."
mkdir -p clean_frames
for f in ${INPUT_PREFIX}*.png; do
    base=$(basename "$f")
    [ -f "clean_frames/$base" ] || magick "$f" -fuzz 10% -transparent white "clean_frames/$base"
done

# Step 2: Build GIF with consistent delay (fixed quoting)
echo "Creating GIF..."
ARGS=()
for f in clean_frames/${INPUT_PREFIX}*.png; do
    ARGS+=(-delay "$DELAY" "$f")
done
magick -dispose Background -loop 0 "${ARGS[@]}" "$OUTPUT_NAME"

echo "Done: $OUTPUT_NAME"
