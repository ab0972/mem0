# 克隆你的fork倉庫到本地
git clone https://github.com/你的帳號/mem0.git

# 進入專案目錄
cd mem0

# 創建Dockerfile
touch Dockerfile

# 用編輯器打開Dockerfile（例如VSCode）
code Dockerfile  # 或使用其他編輯器命令

# 貼入完整Dockerfile內容後保存

# 提交到GitHub
git add Dockerfile
git commit -m "新增Dockerfile用於Zeabur部署"
git push origin main
