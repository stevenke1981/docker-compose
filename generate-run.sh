#!/bin/bash

# 項目名稱
project_name="wordpress"

# 輸出 run.sh 腳本內容
echo "#!/bin/bash" > "$project_name/run.sh"
echo "" >> "$project_name/run.sh"
echo "# 切換到項目目錄" >> "$project_name/run.sh"
echo "cd \"\$(dirname \"\$0\")\"" >> "$project_name/run.sh"
echo "" >> "$project_name/run.sh"
echo "# 執行 docker compose" >> "$project_name/run.sh"
echo "docker-compose up -d" >> "$project_name/run.sh"
echo "" >> "$project_name/run.sh"
echo "echo \"WordPress 已啟動！請在瀏覽器中輸入 http://localhost:80 進行訪問。\"" >> "$project_name/run.sh"

# 修改 run.sh 腳本權限
chmod +x "$project_name/run.sh"

echo "run.sh 腳本已生成到 $project_name 目錄中。"
