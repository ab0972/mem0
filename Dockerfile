FROM python:3.11-slim
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安裝mem0ai及其依賴
RUN pip install mem0ai fastapi uvicorn

# 設置環境變數
ENV MEM0_VECTOR_STORE_PROVIDER=${MEM0_VECTOR_STORE_PROVIDER:-qdrant}
ENV MEM0_VECTOR_STORE_HOST=${MEM0_VECTOR_STORE_HOST}
ENV MEM0_VECTOR_STORE_PORT=${MEM0_VECTOR_STORE_PORT:-6333}
ENV MEM0_VECTOR_STORE_API_KEY=${MEM0_VECTOR_STORE_API_KEY}
ENV MEM0_LOG_LEVEL=${MEM0_LOG_LEVEL:-info}

EXPOSE 8000

# 創建啟動腳本
RUN echo '#!/bin/bash\n\
python -c "from mem0 import MemoryClient; print(\"Mem0 server starting...\"); client = MemoryClient(); print(\"Mem0 client initialized\")"' > /app/start.sh && \
    chmod +x /app/start.sh

# 使用mem0ai包啟動mem0服務
CMD ["/app/start.sh"]
