#!/bin/bash
set -e
set -o pipefail

# Run system update
apt-get update &&

# install curl
apt install curl -y &&

# install tar
apt install tar -y &&

## Install Nodejs

# Check available Node.js Version
apt policy nodejs &&

# Install Nodejs & NPM
apt-get install nodejs -y &&
apt install npm -y &&

# Install Nginx
apt-get install nginx -y &&

# Start nginx
service nginx start &&

# Ensure every time you restart your system Nginx starts up automatically.
systemctl enable nginx &&

# Install nano text editor
apt-get install nano -y &&

# Install pm2
npm install pm2 -g &&

# Configure PM2 to start Express application at startup.
env PATH=$PATH:/usr/local/bin pm2 startup -u ubuntu &&

# Start to listening in port 4000
echo "const http = require('http'); const server = http.createServer((req, res) => { res.statusCode = 200; res.setHeader('Content-Type', 'text/plain'); res.end('Hello, World!'); }); server.listen(4000, () => { console.log('Server running at http://localhost:3000/'); });" > hello-world.js && pm2 start hello-world.js --name backend &&


git clone https://github.com/Marvin-Aguirre/Repo.git &&
cd Repo &&
cd Frontend &&
cd inventory_management_system &&
# Deploying frontend for the first tim
echo REACT_APP_API_URL="${backend_url}:4000" > .env &&

npm install &&
npm run build &&
chmod 777 /var/www/html -R &&
rm -rf /var/www/html/* &&
scp -r ./build/* /var/www/html &&
systemctl restart nginx &&

# Deploying backend for the first time
cd ../../ && 
cd Backend/
echo MONGO_URL="mongodb+srv://maest447:ef4311q6g4y0egsT@cluster0.7d803gv.mongodb.net/Test?retryWrites=true&w=majority" > .env &&
# Start the application with PM2
npm install &&
pm2 delete backend &&
pm2 start index.js --name backend