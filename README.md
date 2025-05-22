# stunnel-flex

**stunnel-flex** is a containerized wrapper around [stunnel](https://www.stunnel.org/) that enables secure TLS encryption for arbitrary TCP services. It features runtime-generated configuration via environment variables, making it flexible for use with Docker Compose, Kubernetes, or standalone Docker deployments.

---

## 🔐 Key Features

- 🔧 **Runtime configuration via environment variables**
- 🧩 **TLS termination for arbitrary TCP services** (e.g., SSH, PostgreSQL)
- 🛡️ **Support for mutual TLS (mTLS)**
- 🐳 **Lightweight Alpine-based image**
- 🔁 **Automatic restarts with Docker Compose**

---

## 🚀 Quick Start

### 1. Create a self-signed certificate (if needed)

```bash
openssl req -x509 -newkey rsa:4096 -keyout stunnel.key -out stunnel.crt -days 365 -nodes
cat stunnel.crt stunnel.key > stunnel.pem
````

### 2. Copy the example config

```bash
cp example.docker-compose.yml docker-compose.yml
```

### 3. Start the container

```bash
docker-compose up -d
```

### 4. Connect to your TLS-secured port

```bash
ssh -p 8443 youruser@yourhost
```

---

## ⚙️ Configuration

stunnel-flex is configured entirely through environment variables:

| Variable            | Description                                   | Default                    |
| ------------------- | --------------------------------------------- | -------------------------- |
| `STUNNEL_ACCEPT`    | Port to listen on (TLS entrypoint)            | `8443`                     |
| `STUNNEL_DEST_HOST` | Destination host to forward decrypted traffic | `host.docker.internal`     |
| `STUNNEL_DEST_PORT` | Destination port                              | `22`                       |
| `STUNNEL_SERVICE`   | Service label in the config                   | `ssh`                      |
| `STUNNEL_DEBUG`     | Debug level (1–7)                             | `7`                        |
| `STUNNEL_CERT`      | Path to the combined PEM certificate          | `/etc/stunnel/stunnel.pem` |

> You may mount your certificate with a volume, e.g., `./stunnel.pem:/etc/stunnel/stunnel.pem`

---

## 📦 Example `docker-compose.yml`

```yaml
version: "3.8"

services:
  stunnel:
    container_name: stunnel-flex
    image: ghcr.io/jctopping/stunnel-flex:latest
    restart: always
    ports:
      - "8443:8443"
    volumes:
      - ./stunnel.pem:/etc/stunnel/stunnel.pem
    environment:
      STUNNEL_ACCEPT: 8443
      STUNNEL_DEST_HOST: host.docker.internal
      STUNNEL_DEST_PORT: 22
      STUNNEL_SERVICE: ssh
      STUNNEL_DEBUG: 7
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

---

## 🔄 Updating the Image

To get the latest version:

```bash
docker pull ghcr.io/jctopping/stunnel-flex:latest
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🤝 Acknowledgments

* [stunnel.org](https://www.stunnel.org/) — TLS tunneling daemon
* [Docker](https://www.docker.com/) — Containerization platform
* Inspired by [`jirutka/stunnel`](https://github.com/jirutka/stunnel) but extended for runtime config