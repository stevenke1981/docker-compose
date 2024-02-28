#!/bin/bash

# 项目文件夹名称
folder_name="wordpress"

# Compose 文件内容
compose_content="services:
  db:
    # 使用支持 amd64 和 arm64 架构的 mariadb 镜像
    image: mariadb:10.6.4-focal
    # 如果您真的想使用 MySQL，取消注释以下行
    # image: mysql:8.0.27
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
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
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress

volumes:
  db_data:"

# 创建文件夹
mkdir -p "$folder_name"

# 创建 Compose 文件
echo "$compose_content" > "$folder_name/docker-compose.yaml"

echo "文件夹 '$folder_name' 和 compose.yaml 文件创建成功！"

# 輸出 run.sh 腳本內容
echo "#!/bin/bash" > "$folder_name/run.sh"
echo "" >> "$folder_name/run.sh"
echo "# 切換到項目目錄" >> "$folder_name/run.sh"
echo "cd \"\$(dirname \"\$0\")\"" >> "$folder_name/run.sh"
echo "" >> "$folder_name/run.sh"
#echo "# 執行 docker compose" >> "$folder_name/run.sh"
#echo "docker-compose up -d" >> "$folder_name/run.sh"
#echo "" >> "$folder_name/run.sh"
#echo "echo \"WordPress 已啟動！請在瀏覽器中輸入 http://localhost:9000 進行訪問。\"" >> "$folder_name/run.sh"

# 修改 run.sh 腳本權限
chmod +x "$folder_name/run.sh"

echo "run.sh 腳本已生成到 $folder_name 目錄中。"
