#! /bin/bash
sudo apt update -y 

sudo apt-get install -y nodejs git

sudo git clone https://github.com/adavidarevalo/CRUD_for_test.git

cd CRUD*

cd server

cat <<EOF | sudo tee .env
PORT=80
DB_NAME=${rds_db_name}
DB_USER=${rds_username}
DB_PASSWORD=${rds_password}
DB_HOST=${rds_db_endpoint}
EOF

sudo apt install -y npm

sudo npm i

sudo npm i -g tsc

sudo npm run build

sudo npm install -g pm2

sudo pm2 start ./dist/index.js --name "express-app"

sudo pm2 startup
sudo pm2 save

