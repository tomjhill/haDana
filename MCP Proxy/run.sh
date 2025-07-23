#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Community Add-on: MCP Proxy
# Runs MCP Proxy
# ==============================================================================

# Get configuration
MODE=$(bashio::config 'mode')
SSE_PORT=$(bashio::config 'sse_port')
SSE_HOST=$(bashio::config 'sse_host')
COMMAND=$(bashio::config 'command')
DEBUG=$(bashio::config 'debug')
PASS_ENVIRONMENT=$(bashio::config 'pass_environment')
TARGET_URL=$(bashio::config 'target_url')

bashio::log.info "Starting MCP Proxy in ${MODE} mode..."

# Build command arguments
ARGS=()

# Add debug flag if enabled
if bashio::config.true 'debug'; then
    ARGS+=("--debug")
fi

# Handle different modes
if [[ "${MODE}" == "sse_server" ]]; then
    bashio::log.info "Running MCP Proxy as SSE server on ${SSE_HOST}:${SSE_PORT}"
    
    # Add SSE server options
    ARGS+=("--sse-port" "${SSE_PORT}")
    ARGS+=("--sse-host" "${SSE_HOST}")
    
    # Add pass environment flag
    if bashio::config.true 'pass_environment'; then
        ARGS+=("--pass-environment")
    else
        ARGS+=("--no-pass-environment")
    fi
    
    # Add environment variables
    if bashio::config.has_value 'env_vars'; then
        for var in $(bashio::config 'env_vars|keys'); do
            key=$(bashio::config "env_vars[${var}].key")
            value=$(bashio::config "env_vars[${var}].value")
            ARGS+=("--env" "${key}" "${value}")
        done
    fi
    
    # Add allowed origins
    if bashio::config.has_value 'allow_origins'; then
        origins=()
        for origin in $(bashio::config 'allow_origins|keys'); do
            origins+=($(bashio::config "allow_origins[${origin}]"))
        done
        if [[ ${#origins[@]} -gt 0 ]]; then
            ARGS+=("--allow-origin")
            ARGS+=("${origins[@]}")
        fi
    fi
    
    # Add command to run
    ARGS+=("${COMMAND}")
    
    # Add command arguments
    if bashio::config.has_value 'args'; then
        ARGS+=("--")
        for arg in $(bashio::config 'args|keys'); do
            ARGS+=($(bashio::config "args[${arg}]"))
        done
    fi
    
elif [[ "${MODE}" == "stdio_to_sse" ]]; then
    bashio::log.info "Running MCP Proxy as stdio to SSE client"
    
    # For stdio_to_sse mode, we need a target URL
    if bashio::config.has_value 'target_url'; then
        TARGET_URL=$(bashio::config 'target_url')
        bashio::log.info "Connecting to SSE server at: ${TARGET_URL}"
        
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
        bashio::log.error "target_url is required for stdio_to_sse mode"
        exit 1
    fi
fi

bashio::log.info "Starting MCP Proxy with arguments: ${ARGS[*]}"

# Set environment variables for uv
export UV_PYTHON_PREFERENCE=only-system
export PATH="/root/.local/bin:$PATH"

# Check if mcp-proxy is available
if ! command -v mcp-proxy &> /dev/null; then
    bashio::log.error "mcp-proxy command not found in PATH"
    bashio::log.error "PATH: $PATH"
    bashio::log.error "Available commands in /root/.local/bin:"
    ls -la /root/.local/bin/ || bashio::log.error "Cannot list /root/.local/bin/"
    exit 1
fi

# Log the version for debugging
bashio::log.info "MCP Proxy version:"
mcp-proxy --help | head -1 || bashio::log.warning "Could not get version info"

# Run MCP Proxy
bashio::log.info "Executing: mcp-proxy ${ARGS[*]}"
exec mcp-proxy "${ARGS[@]}"
