#!/usr/bin/with-contenv bashio

# ==============================================================================

# Home Assistant Community Add-on: MCP Proxy

# Runs MCP Proxy

# ==============================================================================

# Get configuration

MODE=$(bashio::config ‘mode’ ‘sse_server’)
SSE_PORT=$(bashio::config ‘sse_port’ ‘8080’)
SSE_HOST=$(bashio::config ‘sse_host’ ‘0.0.0.0’)
COMMAND=$(bashio::config ‘command’ ‘echo’)
DEBUG=$(bashio::config ‘debug’ ‘false’)
PASS_ENVIRONMENT=$(bashio::config ‘pass_environment’ ‘true’)
TARGET_URL=$(bashio::config ‘target_url’ ‘’)

echo “Starting MCP Proxy in ${MODE} mode…”

# Build command arguments

ARGS=()

# Add debug flag if enabled

if bashio::config.true ‘debug’; then
ARGS+=(”–debug”)
fi

# Handle different modes

if [[ “${MODE}” == “sse_server” ]]; then
echo “Running MCP Proxy as SSE server on ${SSE_HOST}:${SSE_PORT}”

```
# Add SSE server options
ARGS+=("--sse-port" "${SSE_PORT}")
ARGS+=("--sse-host" "${SSE_HOST}")

# Add pass environment flag
if bashio::config.true 'pass_environment'; then
    ARGS+=("--pass-environment")
else
    ARGS+=("--no-pass-environment")
fi

# Add command to run
ARGS+=("${COMMAND}")

# Add command arguments from config
if bashio::config.has_value 'args'; then
    ARGS+=("--")
    for arg in $(bashio::config 'args|keys'); do
        ARGS+=($(bashio::config "args[${arg}]"))
    done
fi
```

elif [[ “${MODE}” == “stdio_to_sse” ]]; then
echo “Running MCP Proxy as stdio to SSE client”

```
# For stdio_to_sse mode, we need a target URL
if [[ -n "${TARGET_URL}" ]]; then
    echo "Connecting to SSE server at: ${TARGET_URL}"
    
    # Add headers if configured
    if bashio::config.has_value 'headers'; then
        for header in $(bashio::config 'headers|keys'); do
            key=$(bashio::config "headers[${header}].key")
            value=$(bashio::config "headers[${header}].value")
            ARGS+=("--headers" "${key}" "${value}")
        done
    fi
    
    ARGS+=("${TARGET_URL}")
else
    echo "ERROR: target_url is required for stdio_to_sse mode"
    exit 1
fi
```

fi

echo “Starting MCP Proxy with arguments: ${ARGS[*]}”

# Set environment variables

export PATH=”/opt/venv/bin:$PATH”

# Check if mcp-proxy is available

if ! command -v mcp-proxy &> /dev/null; then
echo “ERROR: mcp-proxy command not found in PATH”
echo “PATH: $PATH”
exit 1
fi

# Run MCP Proxy

echo “Executing: mcp-proxy ${ARGS[*]}”
exec mcp-proxy “${ARGS[@]}”