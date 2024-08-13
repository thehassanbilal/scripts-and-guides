Here’s a comprehensive documentation for setting up Mongo Express with PM2 and Nginx, including environment variables for configuration and SSL for secure access:

---

# Mongo Express Setup with PM2 and Nginx

## Overview

This documentation provides a step-by-step guide to set up Mongo Express with PM2, Nginx, and SSL to securely manage your MongoDB databases through a web interface.

## Prerequisites

1. **MongoDB**: Installed and running on your server.
2. **Node.js and npm**: Installed on your server.
3. **PM2**: Process manager for Node.js applications.
4. **Nginx**: Web server and reverse proxy.
5. **Certbot**: Tool for obtaining SSL certificates.

## Installation and Configuration

### 1. Install Mongo Express

1. **Install Mongo Express Globally**:

   ```bash
   sudo npm install -g mongo-express
   ```

   Alternatively, you can install it locally in your project directory:

   ```bash
   mkdir /sites/mongo-express
   cd /sites/mongo-express
   npm init -y
   npm install mongo-express
   ```

2. **Create an `.env` File**:

   Create an `.env` file in your Mongo Express directory (e.g., `/sites/mongo-express`) with the following content:

   ```dotenv
   ME_CONFIG_BASICAUTH=true
   ME_CONFIG_BASICAUTH_USERNAME=softbuilders
   ME_CONFIG_BASICAUTH_PASSWORD=Softbuilders@2024
   ME_CONFIG_SITE_SESSIONSECRET=softbuilders
   ME_CONFIG_MONGODB_URL=mongodb://127.0.0.1:27017
   ME_CONFIG_MONGODB_ENABLE_ADMIN=true
   ```

### 2. Configure PM2

1. **Start Mongo Express with PM2**:

   Navigate to the Mongo Express directory and run:

   ```bash
   pm2 start npm --name "mongodb:8081" -- run start
   ```

   This command will start Mongo Express using the `start` script defined in your `package.json` and apply the configuration from your `.env` file.

2. **Save PM2 Process List**:

   To ensure PM2 restarts Mongo Express after a server reboot, save the process list:

   ```bash
   pm2 save
   ```

### 3. Configure Nginx

1. **Create Nginx Configuration File**:

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

### 4. Configure SSL with Certbot

1. **Obtain SSL Certificates**:

   Use Certbot to obtain and install SSL certificates:

   ```bash
   sudo certbot --nginx -d mongo.example.com
   ```

2. **Verify SSL Configuration**:

   Ensure that SSL is properly configured and working by visiting `https://mongo.example.com`.

## Accessing Mongo Express

1. **Open a Web Browser** and navigate to `https://mongo.example.com`.
2. **Authenticate** with the username `softbuilders` and the password `Softbuilders@2024`.

## Troubleshooting

- **PM2 Logs**: Check logs if Mongo Express does not start:

  ```bash
  pm2 logs mongodb:8081
  ```

- **Nginx Logs**: Check Nginx error logs if you encounter issues with the web interface:

  ```bash
  sudo tail -f /var/log/nginx/error.log
  ```

## Security Considerations

- **Strong Passwords**: Use strong passwords for Mongo Express and MongoDB authentication.
- **Network Security**: Restrict access to Mongo Express to trusted IPs or networks if needed.
- **Regular Updates**: Keep Mongo Express, PM2, and Nginx updated to patch security vulnerabilities.

---

This documentation covers the entire process for setting up Mongo Express with PM2 and Nginx, ensuring secure access through HTTPS.
