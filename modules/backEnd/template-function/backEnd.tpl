#! /bin/bash
sudo apt update -y 

sudo apt-get install -y nodejs npm unzip

wget https://codeload.github.com/adavidarevalo/express_mvc/zip/refs/heads/main

sudo unzip main

sudo rm -rf main

cd express*

cat <<EOF | sudo tee .env
PORT=80
DB_NAME=${rds_db_name}
DB_USERNAME=${rds_username}
DB_PASSWORD=${rds_password}
DB_HOST=${rds_db_endpoint}
EOF

sudo npm i

sudo npm install -g pm2

sudo pm2 start server.js --name "express-app"

sudo pm2 startup
sudo pm2 save

