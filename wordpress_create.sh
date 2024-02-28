#!/bin/bash

# 脚本版本
VERSION="1.0.1"

# 帮助信息
function help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help              显示帮助信息"
  echo "  -v, --version           显示脚本版本"
  echo "  -d, --directory         Clash 配置目录 (默认: ./clash)"
  echo "  -c, --config-file        Clash 订阅文件 (默认: config.yaml)"
  echo "  -o, --output-file       生成的文件名 (默认: compose.yaml)"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "  $0 -d /etc/clash"
  echo "  $0 -c my-config.yaml"
  echo "  $0 -o my-compose.yaml"
}

# 显示版本信息
function version() {
  echo "$0 $VERSION"
}

# 解析参数
while getopts ":hvd:c:o:" opt; do
  case $opt in
    h)
      help
      exit 0
      ;;
    v)
      version
      exit 0
      ;;
    d)
      DIRECTORY="$OPTARG"
      ;;
    c)
      CONFIG_FILE="$OPTARG"
      ;;
    o)
      OUTPUT_FILE="$OPTARG"
      ;;
    ?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# 默认参数
DIRECTORY=${DIRECTORY:-./clash}
CONFIG_FILE=${CONFIG_FILE:-config.yaml}
OUTPUT_FILE=${OUTPUT_FILE:-compose.yaml}

# 检查目录是否存在
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory '$DIRECTORY' does not exist."
  echo "Please create the directory or modify the script to specify the correct path."
  exit 1
fi

# 检查配置文件是否存在
if [ ! -f "$DIRECTORY/$CONFIG_FILE" ]; then
  echo "Error: Config file '$DIRECTORY/$CONFIG_FILE' does not exist."
  exit 1
fi

# 生成 `compose.yaml` 文件
cat > "$OUTPUT_FILE" <<EOF
version: '3'

services:
  # Clash
  clash:
    image: dreamacro/clash:latest
    container_name: clash
    volumes:
      - $DIRECTORY/$CONFIG_FILE:/root/.config/clash/config.yaml
    ports:
      - "7890:7890/tcp"
      - "7890:7890/udp"
      - "9090:9090"
    restart: always

  clash-dashboard:
    image: centralx/clash-dashboard
    container_name: clash-dashboard
    ports:
      - "7880:80"
    restart: always
EOF

# 生成 `run.sh` 文件
cat > run.sh <<EOF
#!/bin/bash

docker-compose up -d
EOF

# 提示信息
echo "生成文件成功："
echo "  - compose.yaml"
echo "  - run.sh"

echo "请执行以下命令启动 Clash："
echo "./run.sh"
