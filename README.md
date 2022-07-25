# dbvisitcc

Docker image for Dbvisit MultiPlatform(tm) Control Center

## Getting Started

Due to the licensing, no prebuilt images are available as for now.
In order to build the container, first download a .zip software source
from https://dbvisit.com/try-standby and put it in the cloned directory.
Then build according to the Build section.

## Build prcess

After downloading the installation archive, just run following standard build command:

```
docker build . -t dbvisitcc
```

If you are forced to use a proxy server, then the build comman would be:
```
docker build --build-arg http_proxy=http://proxy-server:port --build-arg https_proxy=http://proxy-server:port . -t dbvisitcc
```

### Usage

The container when first started will generate agent password, unless passed over via environment variable.
If generated, it will be sent to container logs and can be viewed from there. It will be persisted in a volume.

#### Container Parameters

While running you might want to pass agent password (at least for first time run with mounted volume).
You may also consider exposing both ports, for the WEB UI and Agent connect:
```
docker run -p 4433 -p 5533 -e AGENT_PASSWORD="secret" --name dbvisitcc dbvisitcc
```

#### Environment Variables

* `AGENT_PASSWORD` - Password to be configured on all agents to talk to this Control Center. Will be generated if ommited

#### Volumes

* `/usr/dbvisit/persist` - In this volume runtime information will be persisted (certificates, db and configuration)

#### Useful File Locations

* `/usr/dbvisit/standbymp/bin/change-passphrase` - Change agent password on CC - execute from within running container with mounted persistent volume, as the change will be persisted there.

## Authors

* **bartowl** - *Initial work* - [bartowl](https://github.com/bartowl)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
