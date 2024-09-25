Here’s a refactored version of your MongoDB Replica Set Setup Guide, designed for clarity and best practices:

```markdown
# MongoDB Replica Set Setup Guide

This guide details how to set up a MongoDB replica set on a single machine, with each instance running on a different port.

## Prerequisites

- **MongoDB Installed** (e.g., version 7.0.14).
- **Root or Sudo Access** for managing services and permissions.
- Familiarity with **MongoDB** and basic **Linux commands**.

---

## Step-by-Step Setup

### 1. Stop Any Running MongoDB Service

Ensure that no MongoDB instances are running to avoid port conflicts during setup.

```bash
sudo systemctl stop mongod
```

### 2. Create Configuration Files for Each Instance

Each instance requires a separate configuration file with unique ports and paths:

- **Primary instance** config: `/etc/mongod.conf`
- **Secondary instance 1** config: `/etc/mongod2.conf`
- **Secondary instance 2** config: `/etc/mongod3.conf`

#### Example: `/etc/mongod2.conf`
```yaml
# mongod2.conf

storage:
  dbPath: /var/lib/mongodb2
  journal:
    enabled: true
systemLog:
  destination: file
  path: /var/log/mongodb/mongod2.log
  logAppend: true
net:
  port: 27018
  bindIp: 127.0.0.1
replication:
  replSetName: rs0
```
> For **Secondary instance 2**, change the port to `27019` and adjust file paths accordingly.

### 3. Create Required Directories for Data and Logs

Each MongoDB instance needs its own directories for data storage and log files:

```bash
sudo mkdir -p /var/lib/mongodb2 /var/lib/mongodb3
sudo mkdir -p /var/log/mongodb
```

Set the correct permissions:

```bash
sudo chown -R mongodb:mongodb /var/lib/mongodb2 /var/lib/mongodb3
```

### 4. Start MongoDB Instances

Start each instance using its respective configuration file.

#### Primary instance:
```bash
sudo mongod --config /etc/mongod.conf --fork
```

#### Secondary instance 1:
```bash
sudo mongod --config /etc/mongod2.conf --fork
```

#### Secondary instance 2:
```bash
sudo mongod --config /etc/mongod3.conf --fork
```

### 5. Initialize the Replica Set

With all instances running, use the MongoDB shell to initialize the replica set.

1. Open the MongoDB shell:
   ```bash
   mongosh
   ```

2. In the shell, run:
   ```javascript
   rs.initiate({
     _id: "rs0",
     members: [
       { _id: 0, host: "localhost:27017" },
       { _id: 1, host: "localhost:27018" },
       { _id: 2, host: "localhost:27019" }
     ]
   })
   ```

### 6. Verify the Replica Set Status

Check the status to ensure that one node is the **PRIMARY** and the others are **SECONDARY**:

```javascript
rs.status()
```

### 7. (Optional) Enable Authentication and Security

For enhanced security, enable authentication and configure user roles. You can do this by:

1. Adding users with appropriate permissions.
2. Modifying the configuration files to enable access control.

Refer to the [MongoDB Security Documentation](https://www.mongodb.com/docs/manual/security/) for detailed instructions.

---

## Troubleshooting

### Error: `Failed to unlink socket file`

If you encounter the following error:

```
Failed to unlink socket file /tmp/mongodb-27017.sock
```

1. Remove the socket file manually:
   ```bash
   sudo rm /tmp/mongodb-*.sock
   ```
2. Restart the MongoDB instance.

---

## Stopping the Replica Set

To gracefully shut down the replica set, stop each instance, starting with the secondary nodes.

```bash
sudo pkill -f mongod
```

For the primary instance:

```bash
sudo systemctl stop mongod
```

---

## Conclusion

You've successfully set up a MongoDB replica set on a single machine. Keep this guide handy for future configurations.
```

### Key Enhancements:
- **Clear structure** with headings and sections.
- **Best practices** such as stopping MongoDB before starting the setup and adjusting file permissions.
- Added **optional security** steps for enabling authentication.

This guide should serve you well for future reference.
