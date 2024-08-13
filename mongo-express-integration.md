To integrate **mongo-express** on your Ubuntu server and access it via the subdomain **codeinprogress.net**, you'll need to set up mongo-express with PM2, configure Nginx as a reverse proxy, and secure it with SSL using Certbot. Here are the steps to achieve this:

### Step 1: Install Mongo-Express

1. **Clone the mongo-express repository:**
   ```bash
   git clone https://github.com/mongo-express/mongo-express.git
   ```

2. **Navigate to the mongo-express directory:**
   ```bash
   cd mongo-express
   ```

3. **Install dependencies:**
   ```bash
   npm install
   ```

4. **Configure mongo-express:**
   - Copy the default configuration file and edit it:
     ```bash
     cp config.default.js config.js
     ```
   - Open `config.js` and configure your MongoDB connection string and authentication settings. For example:
     ```javascript
     module.exports = {
       mongodb: {
         url: 'mongodb://username:password@localhost:27017/admin',
       },
       site: {
         baseUrl: 'http://codeinprogress.net',
         port: 8081,
       },
       // Add any additional configuration here
     };
     ```

### Step 2: Start Mongo-Express with PM2

1. **Start mongo-express using PM2:**
   ```bash
   pm2 start app.js --name mongo-express
   ```

2. **Set PM2 to start mongo-express on system boot:**
   ```bash
   pm2 save
   pm2 startup
   ```

### Step 3: Configure Nginx

1. **Create a new Nginx configuration file for the subdomain:**
   ```bash
   sudo nano /etc/nginx/sites-available/mongo-express
   ```

2. **Add the following configuration:**
   ```nginx
   server {
       listen 80;
       server_name codeinprogress.net;

       location / {
           proxy_pass http://localhost:8081;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

3. **Enable the configuration by creating a symlink:**
   ```bash
   sudo ln -s /etc/nginx/sites-available/mongo-express /etc/nginx/sites-enabled/
   ```

4. **Test the Nginx configuration and reload:**
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### Step 4: Secure with SSL using Certbot

1. **Install Certbot if you haven't already:**
   ```bash
   sudo apt update
   sudo apt install certbot python3-certbot-nginx
   ```

2. **Obtain and install an SSL certificate:**
   ```bash
   sudo certbot --nginx -d codeinprogress.net
   ```

3. **Follow the prompts to complete the SSL setup. Certbot will automatically configure Nginx to use SSL.

### Step 5: Verify the Setup

1. **Open your browser and navigate to** `https://codeinprogress.net`.
2. **Log in using the credentials you set in the mongo-express configuration.**

### Additional Security

- Consider restricting access to mongo-express using basic authentication or by allowing only certain IP addresses.
- Regularly update your software to ensure security patches are applied.

This setup will allow you to securely access your MongoDB databases using mongo-express from the subdomain **codeinprogress.net** with the credentials you configured. Let me know if you need any further assistance!
