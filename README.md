# 🤖 Discord MCP 

This repository contains the Discord MCP (Multi-Channel Platform) server, a specialized microservice within the Multi-Agent Bot system. It acts as the bridge between Discord’s gateway and REST API and the cyrene-agent (bot-api), enabling dynamic management of multiple Discord bots and real-time message handling.

## ✨ Features

- **Dynamic Bot Management**: Starts and manages individual Discord bot clients concurrently based on tokens provided by the cyrene-agent at runtime.  
- **Gateway Listener**: Connects to Discord’s Gateway via WebSocket to receive real‑time events (messages, reactions, etc.).  
- **Message Forwarding**: Processes incoming Discord messages, enriches them with the correct bot ID and context, and forwards them to the cyrene-agent’s `/discord/receive_message` endpoint.  
- **Tool Exposure**: Exposes Discord‑specific tools (e.g., `send_message_discord`, `get_channel_history`, `create_reaction`, `get_bot_id_discord`) via the FastMCP protocol, allowing agents to interact with Discord.  
- **Credential Injection**: Tools automatically inject the correct Discord bot token and context for the specific bot being used.  
- **Modular & Scalable**: Runs as an independent microservice, allowing for easy scaling and maintenance.

## 🏛️ Architecture Context

The `discord-mcp` is responsible for maintaining a persistent WebSocket connection to Discord’s Gateway.  
Incoming events are received via the socket, parsed and forwarded to the cyrene-agent over HTTP.  
When an agent needs to send a Discord message or perform an action, it calls the corresponding FastMCP tool on the `discord-mcp`, which uses the Discord REST API to execute.

## 🚀 Getting Started

### Prerequisites

* Python 3.12+
* **Discord Bot Token(s)**: Obtain from the [Discord Developer Portal](https://discord.com/developers/applications).
* **Intents**: Configure your bot’s gateway intents (e.g., `GUILD_MESSAGES`, `MESSAGE_CONTENT`) in the Developer Portal and in your code.

### Installation

Clone this repository:

```bash
git clone https://github.com/CyreneAI/discord-mcp.git
cd discord-mcp
```

Install Python dependencies:

```bash
pip install -r requirements.txt
```

### Environment Variables

Create a `.env` file in the root of this `discord-mcp` directory with:

```env
# .env in discord-mcp directory
BOT_API_BASE_URL=http://localhost:8000
```

* `BOT_API_BASE_URL`: Base URL of your cyrene-agent (bot-api) service (e.g., `http://localhost:8000`).
* `DISCORD_GUILD_ID` (optional): If set, the Gateway listener will only subscribe to this guild’s events.

### Running the Application (Local Development)

Run the Discord MCP service:

```bash
uvicorn server:app --reload --host 0.0.0.0 --port 9004
```

The service will connect to Discord’s Gateway, register its FastMCP tools with the `fastmcp-core-server`, and be ready to receive and send messages.

## 🧪 Usage

1. **Create a Discord‑enabled agent** via the cyrene-agent’s API (e.g., using agent-UI), providing `discord_bot_token` in the agent’s secrets.
2. **Invite** the bot to your server using its OAuth2 invite link.
3. **Chat** in any text channel that the bot has access to.

   * Incoming messages will be forwarded to your agent.
   * Agent responses sent via `send_message_discord` will appear in Discord.

## 📁 Project Structure

```
discord-mcp/
├── .env.example
├── .gitignore
├── README.md           # <- This file
├── Dockerfile          # Dockerfile for the discord-mcp service
├── requirements.txt    # Python dependencies for discord-mcp
└── server.py           # FastAPI + discord.py application for the discord-mcp
```
