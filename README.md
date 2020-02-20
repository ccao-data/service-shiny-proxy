
# Data Science Application Server Backend

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
|  |                               +<--------------------------+   10.124.101.3:8080   |
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
data/                      # External dir hosting CCAO data files, must be specified in docker-compose.yaml
shiny_server/              # Top-level dir for hosting ShinyProxy config files
├ application.yml 	   # Configures the actual ShinyProxy app, which apps to launch, logins, etc.
├ docker-compose.yaml  	   # Launches ShinyProxy with the necessary Docker config options/secrets
├ Dockerfile               # Builds the environment and container dependencies for running ShinyProxy
├ README.md                
└ secrets                  # Folder that must be manually created after cloning, contains login credentials
    ├ config.json          # Docker login credentials for watching gitlab repo for updates to branches
    ├ CCAOAPPSRV.txt       # ODBC server credentials for RPIE, formatted as a connection string
    └ CCAODATA.txt         # ODBC server credentials for CCAODATA, formatted as a connection string
```

Configuration of the server is split into two parts:

### Part 1

Part 1 builds the container and environment necessary to run ShinyProxy. This includes a `Dockerfile`, which downloads the dependencies and image needed to run ShinyProxy, and `docker-compose.yaml` which specifies the ports, networks, sockets, secrets, and directories necessary to connect everything together.

`docker-compose.yaml` contains two lines which may need to be edited, depending on your setup. The first, the `DATA_LOCATION:` build arg, specifies the path to your data directory containing CCAO .RData and shapefiles. The second, the file location of `odbc.txt`, specifies the location of a text file containing an MS SQL connection string needed to run database-dependent applications.

### Part 2

Part 2 specifies the actual configuration options for ShinyProxy. All ShinyProxy config is handled via editing the included `application.yml` file. ShinyProxy allows configuration of the name of the server, the apps it launches, and various login options. For a full list of ShinyProxy configuration options, see [here](https://www.shinyproxy.io/configuration/).

## Starting the Server

To run the server, simply run the Docker Compose command inside of this repository. On Linux, this command will be:

```
docker-compose up -d
```
