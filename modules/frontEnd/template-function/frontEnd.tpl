#!/bin/bash

# Actualiza los paquetes
sudo apt update -y > /tmp/userdata.log 2>&1

# Instala git y nginx
sudo apt install -y git nginx >> /tmp/userdata.log 2>&1

# Clona el repositorio
git clone https://github.com/adavidarevalo/CRUD_for_test.git >> /tmp/userdata.log 2>&1

# Cambia al directorio clonado
cd CRUD_for_test || { echo "Directorio CRUD_for_test no encontrado" >> /tmp/userdata.log; exit 1; }

# Cambia al directorio frontend
cd frontend || { echo "Directorio frontend no encontrado" >> /tmp/userdata.log; exit 1; }

cat <<EOF > .env
VITE_API_URL=http://${api_url}
EOF

# Instala nodejs y npm
sudo apt install -y nodejs npm >> /tmp/userdata.log 2>&1

# Instala las dependencias del proyecto
sudo npm install >> /tmp/userdata.log 2>&1

# Instala TypeScript globalmente
sudo npm install -g typescript --force >> /tmp/userdata.log 2>&1

# Construye el proyecto
sudo npm run build >> /tmp/userdata.log 2>&1

# Copia los archivos generados al directorio web de Nginx
sudo cp -r dist/* /var/www/html/ >> /tmp/userdata.log 2>&1

# Configura Nginx para servir los archivos estáticos
sudo cat <<EOF | sudo tee /etc/nginx/sites-available/default >> /tmp/userdata.log 2>&1
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Reinicia el servicio de Nginx
sudo systemctl restart nginx >> /tmp/userdata.log 2>&1
