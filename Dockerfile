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
    && poetry install --no-root

# 明確安裝mem0ai包和依賴
RUN pip install mem0ai uvicorn fastapi

# 複製原始碼
COPY . .

# 安裝當前專案（作為可編輯模式，以便使用本地代碼）
RUN pip install -e .

# 設置環境變數
ENV MEM0_DB_URL=${MEM0_DB_URL}
ENV MEM0_VECTOR_STORE_PROVIDER=${MEM0_VECTOR_STORE_PROVIDER:-qdrant}
ENV MEM0_VECTOR_STORE_HOST=${MEM0_VECTOR_STORE_HOST}
ENV MEM0_VECTOR_STORE_PORT=${MEM0_VECTOR_STORE_PORT:-6333}
ENV MEM0_VECTOR_STORE_API_KEY=${MEM0_VECTOR_STORE_API_KEY}
ENV MEM0_LOG_LEVEL=${MEM0_LOG_LEVEL:-info}

EXPOSE 8000

# 使用 mem0 server 命令啟動，這是更可靠的方式
CMD ["python", "-m", "mem0.server"]

# 備用命令，如果上面的命令不起作用
# CMD ["uvicorn", "mem0.server:app", "--host", "0.0.0.0", "--port", "8000"]
