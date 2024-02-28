#!/bin/bash

# 專案資料夾名稱
folder_name="wordpress"

# 建立資料夾
mkdir -p "$folder_name"

# 讀取使用者輸入

echo "請輸入 MySQL root 密碼："
read mysql_root_password

echo "請輸入 MySQL 使用者名稱："
read mysql_user

echo "請輸入 MySQL 使用者密碼："
read mysql_password

# Compose 檔案內容
compose_content="services:
 db:
  # 使用支持 amd64 和 arm64 架構的 mariadb 镜像
  image: mariadb:10.6.4-focal
  # 如果您真的想使用 MySQL，取消注释以下行
  # image: mysql:8.0.27
  command: '--default-authentication-plugin=mysql_native_password'
  volumes:
   - db_data:/var/lib/mysql
  restart: always
  environment:
   - MYSQL_ROOT_PASSWORD=$mysql_root_password
   - MYSQL_DATABASE=wordpress
   - MYSQL_USER=$mysql_user
   - MYSQL_PASSWORD=$mysql_password
  expose:
   - 3306
   - 33060
 wordpress:
  image: wordpress:latest
  ports:
   - 8081:80
  restart: always
  environment:
   - WORDPRESS_DB_HOST=db
   - WORDPRESS_DB_USER=$mysql_user
   - WORDPRESS_DB_PASSWORD=$mysql_password
   - WORDPRESS_DB_NAME=wordpress

volumes:
 db_data:"

# 建立 Compose 檔案
echo "$compose_content" > "$folder_name/docker-compose.yaml"

# 建立 run.sh 腳本
echo "#!/bin/bash" > "$folder_name/run.sh"
echo "" >> "$folder_name/run.sh"
echo "# 切換到項目目錄" >> "$folder_name/run.sh"
echo "cd \"\$(dirname \"\$0\")\"" >> "$folder_name/run.sh"
echo "" >> "$folder_name/run.sh"
echo "# 執行 docker compose" >> "$folder_name/run.sh"
echo "docker compose up -d" >> "$folder_name/run.sh"
echo "" >> "$folder_name/run.sh"
echo "echo \"WordPress 已啟動！請在瀏覽器中輸入 http://$(hostname -I | awk '{print $1}'):8081 進行訪問。\"" >> "$folder_name/run.sh"

# 修改 run.sh 腳本權限
chmod +x "$folder_name/run.sh"

# 輸出訊息
echo "資料夾 '$folder_name' 和 compose.yaml 文件已建立。"
echo "run.sh 腳本已生成到 $folder_name 目錄中。"
