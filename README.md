# WA API over Kong Gateway

WA API (unofficial) leveraging the power of Kong, a robust and scalable API Gateway.

This project integrates the WA API with Kong Gateway to provide a reliable and efficient solution for managing WhatsApp Web Multi-Device API requests. It combines the flexibility of Kong's plugin ecosystem with the functionality of the WhatsApp API.


## Features

- **Kong Gateway Integration**: Utilize Kong's API management capabilities, including rate limiting, authentication, and logging.
- **Docker Compose Setup**: Simplified deployment using Docker Compose for easy setup and scalability.


## Prerequisites

- Basic understanding of API Gateway concepts and Docker.
- Docker (swarm mode) and Docker Compose and `make` installed on your system.
  If these are not prepared yet, refer to the [System Preparation](#system-preparation) section for guidance.


## Getting Started

### Clone the Repository

Clone the repository to your local machine.
```bash
git clone https://github.com/wurin7i/waini.git
cd waini
```

### System Preparation

Before proceeding with the deployment, ensure that Docker Swarm mode is enabled on your system. Swarm mode is required for managing services and scaling containers effectively. Run the following command to prepare system:

```bash
make prepare
```

## Deploy WA API Gateway

You can deploy the services by running the following command:

```bash
make init <WA number>
```

It will deploy the Kong API Gateway including the Kong Manager (admin panel) and a WhatsApp API service.

Open `http://<your-public-ip>:8002` in your favorite browser to manage gateway services, define routing rules, secure endpoints, throttle requests, and more.


## Available Commands

1) Spin-Up Kong and registered WA services

    ```bash
    make up
    ```

2) Add another WA service

    ```bash
    make deploy 6289xxxxxxxx
    ```

3) Drop WA service

    ```bash
    make drop 6289xxxxxxxx
    ```

4) List registered WA services

    ```bash
    make list
    ```

5) Manage WA service

    ```bash
    make service start|stop|remove 6289xxxxxxxx
    ```

## Todo

- [ ] Secure Kong Manager endpoint
- [ ] Command set for manage WA API routing rules
- [ ] ...


## References

- [Kong Docker Compose Repository](https://github.com/Kong/docker-kong/tree/master/compose)
- [WhatsApp Web Multi-Device API](https://github.com/aldinokemal/go-whatsapp-web-multidevice)


## Contributing

Contributions are welcome! Feel free to submit issues or pull requests to improve this project.


## License

This project is licensed under the MIT License. See the LICENSE file for details.