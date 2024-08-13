To create a GitHub repository that provides step-by-step instructions and configurations for setting up a subdomain to access MongoDB securely, you can structure it with markdown documentation and configuration files. Below is an example of how you can organize your repository and its contents:

### Repository Structure

```
mongodb-subdomain-setup/
│
├── README.md
├── nginx/
│   └── mongo.example.com.conf
└── scripts/
    └── setup-mongo-user.js
```

### Contents

#### README.md

```markdown
# MongoDB Subdomain Access Setup

This repository provides a complete guide to setting up a secure subdomain to access your MongoDB database using Nginx, PM2, and Certbot for SSL.

## Prerequisites

- A running MongoDB instance.
- Nginx installed on your server.
- Certbot installed for SSL certificate management.
- Access to domain DNS settings.
- Basic knowledge of server administration and command-line operations.

## Setup Steps

### Step 1: Create a Subdomain

1. Log in to your DNS provider’s dashboard.
2. Add an `A` record for the subdomain (e.g., `mongo.example.com`) pointing to your server's IP address.

### Step 2: Configure Nginx as a Reverse Proxy

1. Create a new Nginx configuration file for your subdomain:

   ```bash
   sudo nano /etc/nginx/sites-available/mongo.example.com
   ```

2. Add the following configuration:

   ```nginx
   server {
       listen 80;
       server_name mongo.example.com;

       location / {
           proxy_pass http://localhost:27017;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. Enable the configuration:

   ```bash
   sudo ln -s /etc/nginx/sites-available/mongo.example.com /etc/nginx/sites-enabled/
   ```

4. Test and restart Nginx:

   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### Step 3: Secure the Subdomain with SSL

1. Install Certbot if not already installed:

   ```bash
   sudo apt update
   sudo apt install certbot python3-certbot-nginx
   ```

2. Obtain an SSL certificate:

   ```bash
   sudo certbot --nginx -d mongo.example.com
   ```

3. Verify the SSL configuration in Nginx:

   ```nginx
   server {
       listen 443 ssl;
       server_name mongo.example.com;

       ssl_certificate /etc/letsencrypt/live/mongo.example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/mongo.example.com/privkey.pem;

       location / {
           proxy_pass http://localhost:27017;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }

   server {
       listen 80;
       server_name mongo.example.com;
       return 301 https://$server_name$request_uri;
   }
   ```

### Step 4: Secure MongoDB Access

1. Enable authentication in MongoDB:

   ```yaml
   security:
     authorization: enabled
   ```

   Restart MongoDB:

   ```bash
   sudo systemctl restart mongod
   ```

2. Create a MongoDB user:

   ```bash
   mongo < scripts/setup-mongo-user.js
   ```

### Step 5: Connect to MongoDB

Use the following connection string:

```plaintext
mongodb://username:strongpassword@mongo.example.com/yourdatabase?authSource=admin&tls=true
```

## Security Considerations

- Enable authentication on MongoDB.
- Use strong passwords and manage user roles appropriately.
- Monitor logs for unusual access patterns.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

#### nginx/mongo.example.com.conf

```nginx
server {
    listen 80;
    server_name mongo.example.com;

    location / {
        proxy_pass http://localhost:27017;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### scripts/setup-mongo-user.js

```javascript
use admin;
db.createUser({
  user: "username",
  pwd: "strongpassword",
  roles: [ { role: "readWrite", db: "yourdatabase" } ]
});
```

### How to Create the GitHub Repository

1. **Initialize a Git Repository:**

   In your local project directory, run:

   ```bash
   git init
   ```

2. **Add Files to Repository:**

   ```bash
   git add .
   ```

3. **Commit the Files:**

   ```bash
   git commit -m "Initial commit - MongoDB subdomain setup"
   ```

4. **Create a Repository on GitHub:**

   Go to GitHub, create a new repository, and follow the instructions to push your local repository to GitHub.

   ```bash
   git remote add origin https://github.com/your-username/mongodb-subdomain-setup.git
   git branch -M main
   git push -u origin main
   ```

This structure provides a comprehensive guide and the necessary files to set up a secure subdomain for accessing MongoDB, making it easy for others to follow and implement.
