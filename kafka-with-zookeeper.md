
### Setup Kafka and Zookeeper - Step-by-Step Process

#### Prerequisites
- A Linux-based system (e.g., Ubuntu, CentOS, etc.)
- Sudo privileges

---

### 1. Installing Java

```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
```

Verify installation:
```bash
java -version
```

---

### 2. Setting up Kafka

#### Step 1: Download Kafka
```bash
wget https://downloads.apache.org/kafka/3.4.1/kafka_2.13-3.4.1.tgz
tar -xvzf kafka_2.13-3.4.1.tgz
sudo mv kafka_2.13-3.4.1 /usr/local/kafka
```

#### Step 2: Configuring Kafka

Create a configuration directory:
```bash
sudo mkdir -p /usr/local/kafka/config
```

Edit the `server.properties` file:
```bash
sudo nano /usr/local/kafka/config/server.properties
```
(Add configurations as needed, for example, setting `log.dirs`)

#### Step 3: Giving Permissions

Set proper ownership:
```bash
sudo chown -R kafka:kafka /usr/local/kafka/
```

---

### 3. Setting up Zookeeper

#### Step 1: Download Zookeeper
```bash
wget https://downloads.apache.org/zookeeper/stable/apache-zookeeper-3.8.1-bin.tar.gz
tar -xvzf apache-zookeeper-3.8.1-bin.tar.gz
sudo mv apache-zookeeper-3.8.1-bin /usr/local/zookeeper
```

#### Step 2: Configuring Zookeeper

Edit `zoo.cfg`:
```bash
sudo nano /usr/local/zookeeper/conf/zoo.cfg
```
(Set up Zookeeper with necessary configurations)

#### Step 3: Giving Permissions

Set proper ownership:
```bash
sudo chown -R zookeeper:zookeeper /usr/local/zookeeper/
```

---

### 4. Starting Kafka and Zookeeper

#### Starting Kafka
```bash
sudo /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties
```

#### Starting Zookeeper

Start Zookeeper service:
```bash
sudo systemctl start zookeeper
sudo systemctl status zookeeper
```

#### Step 4: Configuring Zookeeper with Systemd

Create a systemd service for Zookeeper:

```bash
sudo nano /etc/systemd/system/zookeeper.service
```

Add the following content:
```
[Unit]
Description=Zookeeper

[Service]
ExecStart=/usr/local/zookeeper/bin/zkServer.sh start
ExecStop=/usr/local/zookeeper/bin/zkServer.sh stop
Restart=always
User=zookeeper
Environment=ZOOCFG=/usr/local/zookeeper/conf/zoo.cfg

[Install]
WantedBy=multi-user.target
```

Reload systemd, start, and enable Zookeeper service:

```bash
sudo systemctl daemon-reload
sudo systemctl start zookeeper
sudo systemctl enable zookeeper
sudo systemctl status zookeeper
```

---

### 5. Additional Steps

- **Systemd Management**: Used systemd to manage Kafka and Zookeeper as services.
- **Configuration Adjustments**: Ensured proper configurations were applied to `server.properties` for Kafka and `zoo.cfg` for Zookeeper.
- **Permissions**: Assigned appropriate ownerships to Kafka and Zookeeper directories using `chown`.

---

### Conclusion

This guide outlines the steps required to set up Apache Kafka and Zookeeper. Adjustments may be needed depending on specific requirements such as adding listeners, security settings, or integrating with other components.

---

You can now save this content as a `.md` file and push it to your GitHub repository!
