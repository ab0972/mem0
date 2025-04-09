FROM python:3.11-slim
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安裝Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# 複製專案文件
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --only main

# 明確安裝uvicorn和fastapi (避免缺少依賴)
RUN pip install uvicorn fastapi

# 複製原始碼
COPY . .

# 設置環境變數
ENV MEM0_DB_URL=${MEM0_DB_URL}
ENV MEM0_VECTOR_STORE_PROVIDER=${MEM0_VECTOR_STORE_PROVIDER:-qdrant}
ENV MEM0_VECTOR_STORE_HOST=${MEM0_VECTOR_STORE_HOST}
ENV MEM0_VECTOR_STORE_PORT=${MEM0_VECTOR_STORE_PORT:-6333}
ENV MEM0_VECTOR_STORE_API_KEY=${MEM0_VECTOR_STORE_API_KEY}
ENV MEM0_LOG_LEVEL=${MEM0_LOG_LEVEL:-info}

EXPOSE 8000

# 提供兩種可能的啟動命令，取消註釋正確的一個
# 方案1: 如果應用入口在server目錄
CMD ["uvicorn", "server.app:app", "--host", "0.0.0.0", "--port", "8000"]
# 方案2: 如果應用入口在mem0目錄
# CMD ["uvicorn", "mem0.api:app", "--host", "0.0.0.0", "--port", "8000"]
