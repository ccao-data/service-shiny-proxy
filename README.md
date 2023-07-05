# Data Department Application Server Backend

This repository hosts the Docker and config files that run the CCAO's application server backend. We use a free, open source package called [ShinyProxy](https://www.shinyproxy.io/) to deploy containerized applications using Docker.

- For a brief primer on Docker and its benefits, see [here](https://medium.com/@kelvin_sp/docker-introduction-what-you-need-to-know-to-start-creating-containers-8ffaf064930a).
- For help documentation and configuration related to ShinyProxy, see [here](https://www.shinyproxy.io/getting-started/).

## Dependencies

The server depends on Docker for building and deployment and Docker Compose for configuration. Both of these must be installed on your system in order to run the server.

- [Docker installation instructions](https://docs.docker.com/install/)
- [Docker Compose installation instructions](https://docs.docker.com/compose/install/)

## Overview / Structure

The server uses ShinyProxy as a frontend application launcher. When a user first visits the server's web address, they see a screen with a list of applications. These applications are the individual Shiny apps that a user can launch. Upon clicking an application, ShinyProxy will connect to the host machine's Docker socket and create a new container specifically for that application. This allows multiple users to run the same Shiny app concurrently.

The server has the following general structure:

```
+-------------------------------------------------------+
|                                                       |
|  Host Machine                                         |
|                                                       |
|  +-------------------------------+                    |      +-----------------------+
|  |                               |                    |      |                       |
|  |                               +-------------------------->+   External Website    |
|  |  ShinyProxy Docker Container  |                    |      |                       |
|  |                               +<--------------------------+  10.129.122.29:8080   |
|  |                               |                    |      |                       |
|  +-------------------------------+                    |      +------+------+-----+---+
|                           ||                          |             |      |     |
|                           ++                          |        +----+      |     +----+
|                  Docker System Daemon                 |        |           |          |
|                            +                          |        |           |          |
|         +------------------------------------+        |        |           |          |
|         |                  |                 |        |   +----+---+  +----+---+  +---+----+
|         |                  |                 |        |   |        |  |        |  |        |
|  +------+------+  +--------+------+  +-------+-----+  |   | User 1 |  | User 2 |  | User 3 |
|  |             |  |               |  |             |  |   |        |  |        |  |        |
|  |   Docker +  |  |    Docker +   |  |   Docker +  |  |   +--------+  +--------+  +--------+
|  | Shiny App 1 |  |  Shiny App 1  |  | Shiny App 2 |  |
|  |             |  |               |  |             |  |
|  |             |  |               |  |             |  |
|  +-------------+  +---------------+  +-------------+  |
|                                                       |
+-------------------------------------------------------+
```

## Configuration

Files in this directory have the following structure and functions:

```
service-shiny-proxy/  # Top-level dir for hosting ShinyProxy config files
├ application.yml     # Configures the actual ShinyProxy app, which apps to launch, logins, etc.
├ docker-compose.yaml # Launches ShinyProxy with the necessary Docker config options/secrets
├ Dockerfile          # Builds the environment and container dependencies for running ShinyProxy
├ .env                # File containing environmental variables used in docker-compose.yaml
├ README.md
└ secrets             # Folder that must be manually created after cloning, contains login credentials
    └ ENV_FILE        # Text file containing ODBC connection strings passed as env variables
```

Configuration of the server is split into two parts:

### Part 1

Part 1 builds the container and environment necessary to run ShinyProxy. This includes a `Dockerfile`, which downloads the dependencies and image needed to run ShinyProxy, and `docker-compose.yaml` which specifies the ports, networks, sockets, secrets, and directories necessary to connect everything together.

### Part 2

Part 2 specifies the actual configuration options for ShinyProxy. All ShinyProxy configuration is handled via editing the included `application.yml` file. ShinyProxy allows configuration of the name of the server, the apps it launches, and various login options. For a full list of ShinyProxy configuration options, see [here](https://www.shinyproxy.io/documentation/configuration/).

## Starting the Server

To run the server, simply run the Docker Compose command inside of this repository. On Linux, this command will be:

```
docker-compose up -d
```

The `-d` flag runs Docker Compose in detached mode, meaning you do not have to keep your SSH session open in order for the server to continue running.

The URL of the app launcher will be the IP address of the server with port 8080 appended. For example, if the server IP is 192.168.1.12, then ShinyProxy's IP will be 192.168.1.12:8080.
