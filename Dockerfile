FROM ghcr.io/cyreneai/base-mcp:latest

# Set working directory
WORKDIR /app

# Copy & install dependencies
COPY requirements.txt .  
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY server.py .

# Standard MCP port in Kubernetes
EXPOSE 9004

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9004"]
