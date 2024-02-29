#!/bin/bash
#version 1.0.0

# Get user input for server name and desired client name
read -p "Enter your VPN server name: " SERVER_NAME
read -p "Enter a descriptive name for your client certificate: " CLIENT_NAME

# Generate the compose.yaml file
cat <<EOF > compose.yaml
version: "3.8"

services:
  openvpn:
    image: kylemanna/openvpn
    volumes:
      - ./server/keys:/etc/openvpn
      - ./client/$CLIENT_NAME:/etc/openvpn/client
    ports:
      - "1194:1194/udp"
    cap_add:
      - NET_ADMIN

volumes:
  ovpn-data:

networks:
  default:
    external:
      name: my-network

EOF

# Generate the run.sh script
cat <<EOF > run.sh
#!/bin/bash

# Initialize the OpenVPN data directory
docker volume create ovpn-data

# Start OpenVPN server
docker compose up -d

# Generate server configuration and keys
docker exec -it openvpn ovpn_genconfig -u udp://$SERVER_NAME
docker exec -it openvpn ovpn_initpki

# Move generated keys to server directory
mv server/ca.crt server/keys/
mv server/server.conf server/keys/
mv server/server.key server/keys/

# Generate client certificate without passphrase
docker exec -it openvpn easyrsa build-client-full $CLIENT_NAME nopass

# Move client certificate and key to client directory
mv client/$CLIENT_NAME.crt client/$CLIENT_NAME/
mv client/$CLIENT_NAME.key client/$CLIENT_NAME/

# Generate client configuration with embedded certificates
docker exec -it openvpn ovpn_getclient $CLIENT_NAME > client/$CLIENT_NAME/$CLIENT_NAME.ovpn

echo "OpenVPN server and client configuration files generated!"

# Optionally, remove temporary volume (uncomment to remove after completion)
# docker volume rm ovpn-data

EOF

# Make the run.sh script executable
chmod +x run.sh

echo "Generated compose.yaml and run.sh files successfully."
