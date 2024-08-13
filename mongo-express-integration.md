If you've cloned a repository for Mongo Express instead of installing it, you'll need to follow a slightly different set of instructions to set up and run Mongo Express. Here’s a revised guide for running Mongo Express from a cloned repository:

---

# Mongo Express Setup from a Cloned Repository

## Overview

This guide explains how to set up Mongo Express from a cloned Git repository, configure it with environment variables, and run it using PM2. It also covers configuring Nginx for reverse proxy and securing the connection with SSL using Certbot.

## Prerequisites

1. **Node.js and npm**: Installed on your server.
2. **PM2**: Process manager for Node.js applications.
3. **Nginx**: Web server and reverse proxy.
4. **Certbot**: Tool for obtaining SSL certificates.
5. **Git**: For cloning the repository.

## Steps

### 1. Clone the Mongo Express Repository

1. **Clone the Repository**:

   Navigate to the directory where you want to clone the repository and run:

   ```bash
   git clone https://github.com/mongo-express/mongo-express.git
   ```

2. **Navigate to the Cloned Directory**:

   ```bash
   cd mongo-express
   ```

### 2. Install Dependencies

1. **Install Dependencies**:

   Run the following command to install the necessary dependencies:

   ```bash
   npm install
   ```

### 3. Configure Mongo Express

1. **Create an `.env` File**:

   In the root of the cloned repository directory, create a `.env` file with the following content:

   ```dotenv
   ME_CONFIG_BASICAUTH=true
   ME_CONFIG_BASICAUTH_USERNAME=softbuilders
   ME_CONFIG_BASICAUTH_PASSWORD=Softbuilders@2024
   ME_CONFIG_SITE_SESSIONSECRET=softbuilders
   ME_CONFIG_MONGODB_URL=mongodb://127.0.0.1:27017
   ME_CONFIG_MONGODB_ENABLE_ADMIN=true
   ```

   This file provides configuration settings through environment variables.

### 4. Configure PM2

1. **Start Mongo Express with PM2**:

   Use PM2 to start Mongo Express with the `npm start` command:

   ```bash
   pm2 start npm --name "mongodb:8081" -- run start
   ```

2. **Save the PM2 Process List**:

   To ensure PM2 restarts Mongo Express on server reboot, save the process list:

   ```bash
   pm2 save
   ```

### 5. Configure Nginx

1. **Create an Nginx Configuration File**:

   Create a new Nginx configuration file for Mongo Express:

   ```bash
   sudo nano /etc/nginx/sites-available/mongo.example.com
   ```

2. **Add the Following Configuration**:

   ```nginx
   server {
       listen 80;
       server_name mongo.example.com;

       location / {
           proxy_pass http://localhost:8081;  # Default Mongo Express port
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   server {
       listen 443 ssl;
       server_name mongo.example.com;

       ssl_certificate /etc/letsencrypt/live/mongo.example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/mongo.example.com/privkey.pem;

       location / {
           proxy_pass http://localhost:8081;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   server {
       listen 80;
       server_name mongo.example.com;
       return 301 https://$server_name$request_uri;
   }
   ```

3. **Enable the Nginx Configuration**:

   Create a symbolic link to enable the site:

   ```bash
   sudo ln -s /etc/nginx/sites-available/mongo.example.com /etc/nginx/sites-enabled/
   ```

4. **Test and Restart Nginx**:

   Test the Nginx configuration for syntax errors:

   ```bash
   sudo nginx -t
   ```

   Restart Nginx to apply the changes:

   ```bash
   sudo systemctl restart nginx
   ```

### 6. Configure SSL with Certbot

1. **Obtain SSL Certificates**:

   Use Certbot to obtain and install SSL certificates:

   ```bash
   sudo certbot --nginx -d mongo.example.com
   ```

2. **Verify SSL Configuration**:

   Check that SSL is correctly configured and functioning by visiting `https://mongo.example.com`.

## Accessing Mongo Express

1. **Open a Web Browser** and navigate to `https://mongo.example.com`.
2. **Authenticate** with the username `softbuilders` and the password `Softbuilders@2024`.

## Troubleshooting

- **PM2 Logs**: Check PM2 logs if Mongo Express does not start:

  ```bash
  pm2 logs mongodb:8081
  ```

- **Nginx Logs**: Check Nginx error logs if there are issues with the web interface:

  ```bash
  sudo tail -f /var/log/nginx/error.log
  ```

## Security Considerations

- **Strong Passwords**: Ensure that passwords for Mongo Express and MongoDB are strong and secure.
- **Network Security**: Restrict access to Mongo Express to trusted IPs or networks if necessary.
- **Regular Updates**: Keep Mongo Express, PM2, and Nginx updated to address any security vulnerabilities.

---

This guide provides a comprehensive overview of setting up Mongo Express from a cloned repository and configuring it with PM2 and Nginx, including SSL for secure access.
