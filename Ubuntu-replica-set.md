```markdown
# MongoDB Replica Set Setup Guide

This guide will walk you through the steps to set up a MongoDB replica set on the same machine, using different ports for each instance.

## Prerequisites

- **MongoDB installed** on your system (we used version 7.0.14).
- **Root access** to configure services and permissions.
- Ensure that you have basic knowledge of working with **MongoDB** and **Linux commands**.

## Steps

### 1. Stop MongoDB Service

Before starting the setup, ensure that any running MongoDB instance is stopped.

```bash
sudo systemctl stop mongod
```

### 2. Create Configuration Files

You will need to run multiple MongoDB instances on the same machine, so create separate configuration files for each instance:

- **Primary instance** (`/etc/mongod.conf`)
- **Secondary instance 1** (`/etc/mongod2.conf`)
- **Secondary instance 2** (`/etc/mongod3.conf`)

#### Example of `/etc/mongod2.conf`:
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

Repeat for **Secondary instance 2** but change the port to `27019` and paths accordingly.

### 3. Create Required Directories

Create the directories for data and logs for the second and third instances:

```bash
sudo mkdir -p /var/lib/mongodb2 /var/lib/mongodb3
sudo mkdir -p /var/log/mongodb
```

Ensure proper permissions are set:

```bash
sudo chown -R mongodb:mongodb /var/lib/mongodb2 /var/lib/mongodb3
```

### 4. Start MongoDB Instances

Start each MongoDB instance using their respective configuration files.

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

### 5. Initiate the Replica Set

Once all instances are running, initiate the replica set from the **MongoDB shell**:

```bash
mongosh
```

In the shell, initiate the replica set:

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

### 6. Check Replica Set Status

Check the status of the replica set to ensure all nodes are connected:

```javascript
rs.status()
```

You should see output indicating that one node is the **PRIMARY** and the others are **SECONDARY**.

### 7. Enable Authentication and Security (Optional but Recommended)

You may want to enable authentication and add users for secure access. To do this, follow these steps:

1. **Add users with appropriate roles**.
2. **Enable access control** in the config files.

For more information, refer to [MongoDB's security documentation](https://www.mongodb.com/docs/manual/security/).

---

## Troubleshooting

### Error: `Failed to unlink socket file`

If you see the following error:

```
Failed to unlink socket file /tmp/mongodb-27017.sock
```

Run MongoDB with elevated privileges or clear the socket file manually:

```bash
sudo rm /tmp/mongodb-*.sock
```

Then restart the MongoDB instance.

---

## Stopping the Replica Set

To stop the replica set, stop each MongoDB instance in the reverse order:

```bash
sudo systemctl stop mongod
```

For the secondary instances, use:

```bash
sudo pkill -f mongod
```

---

## Conclusion

You have successfully set up a MongoDB replica set on your local machine. Use this guide whenever you need to configure a new replica set.
```

---

You can modify this guide to fit your exact needs. Let me know if you'd like any changes or additions!
