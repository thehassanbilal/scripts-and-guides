Here is the complete markdown file content that you can copy and save as `pm2_commands.md`:

```markdown
# Basic PM2 Commands for MERN Application

## Start and Manage Applications

- **Start the application with a specific script (e.g., app.js) and name:**
  ```bash
  pm2 start app.js --name "mern-app"
  ```

- **Start the application with a specific environment:**

- **Run NestJS:**
  ```bash
  pm2 start npm --name "app-name" -- run "start:prod"
  ```

- **Run NextJS npm:**
  ```bash
  pm2 start --name "nextjs-app" -- start
  ```

- **Run NextJS yarn:**
  ```bash
  pm2 start yarn --name "app-name" -- run start
  ```

- **Start the application with clustering mode (automatic load balancing):**
  ```bash
  pm2 start app.js --name "mern-app" -i max
  ```

- **List all processes managed by PM2:**
  ```bash
  pm2 list
  ```

- **Show detailed information about a specific process:**
  ```bash
  pm2 show mern-app
  ```

- **Restart a process:**
  ```bash
  pm2 restart mern-app
  ```

- **Stop a process:**
  ```bash
  pm2 stop mern-app
  ```

- **Delete a process:**
  ```bash
  pm2 delete mern-app
  ```

## Save and Manage Process Lists

- **Save the current PM2 process list (useful for reboots):**
  ```bash
  pm2 save
  ```

- **Reload all processes (zero-downtime reload):**
  ```bash
  pm2 reload all
  ```

## Logs and Monitoring

- **View the logs of a specific application:**
  ```bash
  pm2 logs mern-app
  ```

- **Monitor the CPU and memory usage of all applications:**
  ```bash
  pm2 monit
  ```

## Ecosystem File

- **Generate an ecosystem file (`ecosystem.config.js`) for defining applications:**
  ```bash
  pm2 ecosystem
  ```

- **Start all applications defined in the ecosystem file:**
  ```bash
  pm2 start ecosystem.config.js
  ```

- **Restart all applications defined in the ecosystem file:**
  ```bash
  pm2 restart ecosystem.config.js
  ```

- **Stop all applications defined in the ecosystem file:**
  ```bash
  pm2 stop ecosystem.config.js
  ```

## Additional Commands

- **Delete all applications managed by PM2:**
  ```bash
  pm2 delete all
  ```

- **Update PM2 to the latest version:**
  ```bash
  pm2 update
  ```

- **List all available PM2 commands:**
  ```bash
  pm2 help
  ```
```
