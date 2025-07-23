Home Assistant Add-on: MCP Proxy

MCP Proxy add-on for Home Assistant, enabling you to connect to MCP servers that run on SSE transport, or expose stdio servers as an SSE server.
About
The MCP Proxy is a tool that lets you switch between server transports for the Model Context Protocol (MCP). This add-on packages the mcp-proxy tool to run as a Home Assistant service.
There are two supported modes:

SSE Server Mode (sse_server): Run a proxy server exposing an SSE server that connects to a local stdio server. This allows remote connections to local stdio servers.
stdio to SSE Client Mode (stdio_to_sse): Run a proxy that connects to a remote SSE server and exposes it as a stdio interface.

Installation

Navigate in your Home Assistant frontend to Settings → Add-ons → Add-on Store.
Add this repository by clicking the three dots in the top right corner and selecting "Repositories".
Add the repository URL: https://github.com/YOUR_USERNAME/hassio-addons
Find the "MCP Proxy" add-on and click install.
Click the "INSTALL" button to install the add-on.
After the add-on is installed, configure it according to your needs.
Click the "START" button to start the add-on.

Configuration
SSE Server Mode Configuration
This mode runs mcp-proxy as an SSE server that bridges to local stdio MCP servers:
yamlmode: sse_server
sse_port: 8080
sse_host: "0.0.0.0"
command: "uvx"
args: ["mcp-server-fetch"]
env_vars:
  - key: "USER_AGENT"
    value: "MyApp/1.0"
pass_environment: true
allow_origins:
  - "*"
debug: false
stdio to SSE Client Mode Configuration
This mode connects mcp-proxy to a remote SSE server:
yamlmode: stdio_to_sse
target_url: "http://homeassistant.local:8123/mcp_server/sse"
headers:
  - key: "Authorization"
    value: "Bearer YOUR_LONG_LIVED_ACCESS_TOKEN"
debug: false
Configuration Options
OptionTypeRequiredDefaultDescriptionmodestringYessse_serverOperation mode: sse_server or stdio_to_ssesse_portintNo8080Port for SSE server (sse_server mode only)sse_hoststringNo0.0.0.0Host for SSE server (sse_server mode only)commandstringNoechoCommand to run for stdio server (sse_server mode only)argslistNo["Hello from MCP Proxy"]Arguments for the command (sse_server mode only)env_varslistNo[]Environment variables for the stdio serverallow_originslistNo[]Allowed CORS origins for SSE serverpass_environmentboolNotruePass through environment variables to stdio servertarget_urlstringNo-Target SSE server URL (stdio_to_sse mode only)headerslistNo[]HTTP headers for SSE client (stdio_to_sse mode only)debugboolNofalseEnable debug logging
Example Use Cases
1. Expose Home Assistant MCP Server for Claude Desktop
Configure the add-on to connect Claude Desktop to your Home Assistant MCP server:
yamlmode: stdio_to_sse
target_url: "http://homeassistant.local:8123/mcp_server/sse"
headers:
  - key: "Authorization"
    value: "Bearer YOUR_LONG_LIVED_ACCESS_TOKEN"
debug: false
Then configure Claude Desktop to use this proxy in your claude_desktop_config.json:
json{
  "mcpServers": {
    "Home Assistant": {
      "command": "mcp-proxy",
      "args": ["http://localhost:8080/sse"]
    }
  }
}
2. Expose Local MCP Server as SSE
Run a local MCP server and expose it via SSE:
yamlmode: sse_server
sse_port: 8080
sse_host: "0.0.0.0"
command: "uvx"
args: ["mcp-server-fetch"]
allow_origins:
  - "*"
3. Bridge to Custom MCP Server
Run your own MCP server through the proxy:
yamlmode: sse_server
sse_port: 8080
sse_host: "0.0.0.0"
command: "python"
args: ["my_mcp_server.py"]
env_vars:
  - key: "API_KEY"
    value: "your-api-key"
  - key: "DEBUG"
    value: "true"
pass_environment: false
Usage with Home Assistant MCP Integration
If you have the Home Assistant MCP Server integration enabled, you can use this add-on to make it accessible to MCP clients that only support stdio transport (like Claude Desktop).

Enable the Home Assistant MCP Server integration
Create a long-lived access token
Configure this add-on in stdio_to_sse mode with your Home Assistant URL and token
Configure your MCP client to connect to this add-on's stdio interface
