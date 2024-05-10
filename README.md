# vrising-server
Container for running V-Rising dedicated on Debian Linux with Wine.

## Usage

Run the container directly, build locally, use the compose file, run in a k8s environment with the helm chart... what ever floats your boat.

## Environment Variables

| Name | Description | Default | Required |
| ---- | ----------- | ------- | -------- |
| SERVER_NAME | Name for the Server | VRising Containerized | False |
| SERVER_PASSWORD | Password for the server | None | True |
| GAME_PORT | Port for server connections | 27015 | False |
| QUERY_PORT | Port for steam query of server | 27016 | False |
| DESCRIPTION | Description for server | A VRising Server | False |
| BIND_ADDRESS | IP address for server to listen on | 0.0.0.0 | False |
| HIDE_IP | Hide IP on server browser | True | False |
| LOWER_FPS_WHEN_EMPTY | Lower server FPS when server is empty | True | False |
| SECURE | Enable Steam VAC | True | False |

### Podman

```bash
podman run \
  --detach \
  --name vrising-server \
  --mount type=volume,source=vrising-persistent-data,target=/home/steam/vrising/save-data \
  --publish 27015:27015/udp \
  --publish 27016:27016/udp \
  --env-file vars.env \
  sknnr/vrising-dedicated-server:latest
```

### Docker

```bash
Docker run \
  --detach \
  --name vrising-server \
  --mount type=volume,source=vrising-persistent-data,target=/home/steam/vrising/save-data \
  --publish 27015:27015/udp \
  --publish 27016:27016/udp \
  --env-file vars.env \
  sknnr/vrising-dedicated-server:latest
```

### Docker Compose

To use Docker Compose, either clone this repo or copy the compose.yaml file out of the container directory to your local machine. Edit the compose file to change the environment variables to the values you desire and then save the changes. Once you have made your changes, from the same directory that contains the compose and the env files, simply run:

```bash 
docker-compose up -d
```

To bring the container down:

```bash
docker-compose down
```

compose.yaml:

```yaml
services:
  vrising:
    image: sknnr/vrising-dedicated-server:latest
    ports:
      - "27015:27015/udp"
      - "27016:27016/udp"
    environment:
      - SERVER_NAME="VRising Containerized"
      - SERVER_PASSWORD="PleaseChangeMe"
      - GAME_PORT=27015
      - QUERY_PORT=27015
      - DESCRIPTION="A VRising Server"
      - BIND_ADDRESS=0.0.0.0
      - HIDE_IP=true
      - LOWER_FPS_EMPTY=true
      - SECURE=true
    volumes:
      - vrising-persistent-data:/opt/steam/vrising/save-data
volumes:
  vrising-persistent-data:
```

### Kubernetes

I've built a Helm chart and have included it in the `helm` directory within this repo. Modify the `values.yaml` file to your liking and install the chart into your cluster. Be sure to create and specify a namespace as I did not include a template for provisioning a namespace.

### Troubleshooting & Support

Q: I can't connect to or find my server!
A: You have a networking issue or misconfiguration, this a fault with the image.

Q: Why does the image always download the game files?
A: The game files are not persisted, only the save game data. The image will check if the data is present when started, if it's not there it will download it, if it needs updated it will download it.

Q: How do I update the server?
A: Either destroy the container and recreate it (without destroying the volume of course) or stop and start the container.

Q: Why does my container crash or fail to start?
A: Could be many reasons, none of them is the fault of this image. If it cannot reach out to steam to pull the server files, it will crash. If wine exits for any reason it will kill the container. Double check all your settings, your container host configurations and packages, etc. You know, troubleshoot.

I am providing this as is. I seriously do not have time to help with every issue. Feel free to fork or do whatever you want with the code here.

I've tested this container with Podman, Docker, and Kubernetes on multiple different servers. If you are having issues with ANYTHING it is due to your setup.

If you have suggestions for improvements, feel free to submit a merge request.

Have fun.

