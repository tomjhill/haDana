#!/bin/bash

echo "Starting MCP Proxy..."

# Read configuration from options.json if it exists
if [ -f /data/options.json ]; then
    MODE=$(jq -r '.mode // "sse_server"' /data/options.json)
    SSE_PORT=$(jq -r '.sse_port // 8080' /data/options.json)
    SSE_HOST=$(jq -r '.sse_host // "0.0.0.0"' /data/options.json)
    TARGET_URL=$(jq -r '.target_url // ""' /data/options.json)
    DEBUG=$(jq -r '.debug // false' /data/options.json)
else
    echo "No configuration found, using defaults"
    MODE="sse_server"
    SSE_PORT=8080
    SSE_HOST="0.0.0.0"
    TARGET_URL=""
    DEBUG=false
fi

echo "Mode: $MODE"

# Build arguments
ARGS=()

if [ "$DEBUG" = "true" ]; then
    ARGS+=("--debug")
fi

if [ "$MODE" = "sse_server" ]; then
    echo "Running SSE server mode on $SSE_HOST:$SSE_PORT"
    ARGS+=("--sse-port" "$SSE_PORT")
    ARGS+=("--sse-host" "$SSE_HOST")
    ARGS+=("echo" "Hello from MCP Proxy")
    
elif [ "$MODE" = "stdio_to_sse" ]; then
    echo "Running stdio to SSE mode"
    if [ -n "$TARGET_URL" ]; then
        echo "Target URL: $TARGET_URL"
        
        # Add headers if they exist
        if [ -f /data/options.json ]; then
            HEADER_COUNT=$(jq -r '.headers | length' /data/options.json 2>/dev/null || echo "0")
            for ((i=0; i<HEADER_COUNT; i++)); do
                KEY=$(jq -r ".headers[$i].key" /data/options.json)
                VALUE=$(jq -r ".headers[$i].value" /data/options.json)
                ARGS+=("--headers" "$KEY" "$VALUE")
            done
        fi
        
        ARGS+=("$TARGET_URL")
    else
        echo "ERROR: target_url required for stdio_to_sse mode"
        exit 1
    fi
fi

echo "Executing: mcp-proxy ${ARGS[*]}"
exec mcp-proxy "${ARGS[@]}"