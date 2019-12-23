
# Data Science Application Server Backend

This repository hosts the Docker and config files that run the CCAO's application server backend. We use a free, open source package called [ShinyProxy](https://www.shinyproxy.io/) to deploy containerized applications using Docker. 

- For a brief primer on Docker and its benefits, see [here](https://medium.com/@kelvin_sp/docker-introduction-what-you-need-to-know-to-start-creating-containers-8ffaf064930a).
- For help documentation and configuration related to ShinyProxy, see [here](https://www.shinyproxy.io/getting-started/).

## Overview / Structure

The server uses ShinyProxy as a frontend application launcher. When a user first visits the server's IP address, they see a screen with a list of applications. These applications are the individual Shiny apps that a user can launch. Upon clicking an application, ShinyProxy will connect to the host machine's Docker socket and create a new container specifically for that application. This allows multiple users to run the same Shiny app concurrently.

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
├ README.md                # This file
└ secrets
    └ odbc.txt             # ODBC server credentials formatted as a connection string
```

Configuration of the server is split into two parts:

### Part 1

The first part builds the container and environment necessary to run ShinyProxy. This includes a `Dockerfile`, which downloads the dependencies and image needed to run ShinyProxy, and `docker-compose.yaml` which specifies the ports, networks, sockets, secrets, and directories necessary to connect everything together.

`docker-compose.yaml` contains two lines which may need to be edited, depending on your setup. The first, the `DATA_LOCATION:` build arg, specified the path to your data directory containing CCAO .RData and shapefiles. The second, the file location of `odbc.txt`, specifies the location of a text file containing an MS SQL connection string needed to run database-dependent applications.

### Part 2

The second part specifies the actual config options for ShinyProxy. The included `application.yml` allows configuration of the name of the server, the apps it launches, and various login options. For a full list of ShinyProxy configuration options, see [here](https://www.shinyproxy.io/configuration/). 


