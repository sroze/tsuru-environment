# Docker Tsuru environment

This Docker image contains a configured Tsuru environment.
There's no user yet, no platform.

**Note:** this Tsuru environment use [Docker in Docker](https://github.com/jpetazzo/dind) and don't have to be used in production environments, this is for testing and development only.

## Run

```
docker run -it --privileged sroze/tsuru-environment
```

**Note**: It have to be run in privileged mode because it's using Docker inside Docker.

## Getting started

Find the IP address of your container with `docker inspect` and then add the tsuru target:
```
tsuru target-add default http://[IP_ADDRESS]:8080
tsuru target-set default
```

Then, you'll need to create your user and add it the the `admin` group:
```
tsuru user-create your-email@example.com
tsuru login your-email@example.com
tsuru team-create admin
```

Then, install the needed platforms. For instance, for the PHP platform:
```
tsuru-admin platform-add php --dockerfile https://raw.githubusercontent.com/tsuru/basebuilder/master/php/Dockerfile
```

## Usage

You can now create an application:
```
tsuru app-create example php
```

To deploy your application, you'll need to add the Git Tsuru remote and push your code:
```
git remote add tsuru git@[IP_ADDRESS]:example.git
git push tsuru master
```

