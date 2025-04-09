FROM python:3.11-slim
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 複製整個倉庫
COPY . .

# 安裝Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# 使用Poetry安裝依賴
RUN poetry config virtualenvs.create false \
    && poetry install --only main

# 安裝服務器依賴
RUN cd server && pip install -e .

# 設置環境變數
ENV MEM0_VECTOR_STORE_PROVIDER=${MEM0_VECTOR_STORE_PROVIDER:-qdrant}
ENV MEM0_VECTOR_STORE_HOST=${MEM0_VECTOR_STORE_HOST}
ENV MEM0_VECTOR_STORE_PORT=${MEM0_VECTOR_STORE_PORT:-6333}
ENV MEM0_VECTOR_STORE_API_KEY=${MEM0_VECTOR_STORE_API_KEY}
ENV MEM0_LOG_LEVEL=${MEM0_LOG_LEVEL:-info}

EXPOSE 8000

# 直接從server目錄啟動
CMD ["uvicorn", "server.app:app", "--host", "0.0.0.0", "--port", "8000"]
