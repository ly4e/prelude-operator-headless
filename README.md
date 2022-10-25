# prelude-operator-headless
Containerization of the "Prelude Operator" headless executable
aka: Creating a container to assist in running a headless "Prelude Operator" instance
| Prelude's Website: https://www.prelude.org/

## Example of what is expected at an interactive shell
```bash
./headless --sessionToken=${SESSIONTOKEN} --accountEmail=${ACCOUNTEMAIL} --accountToken=${ACCOUNTOKEN} --accountSecret=${ACCOUNTSECRET}
```

### NOTE: This container's default is to display the "help" menu if no parameters are supplied
```bash
docker run --rm ly4e/prelude-operator:latest
```
 will result in `./headless --help` being executed.

----
----
---
# Starting the container (exposing default ports)
```bash
docker run --rm -p 2323:2323/tcp -p 4545:4545/udp -p 3391:3391/tcp -p 8888:8888/tcp -p 50051:50051/tcp -p 8443:8443/tcp ly4e/prelude-operator:latest --sessionToken=${SESSIONTOKEN} --accountEmail=${ACCOUNTEMAIL} --accountToken=${ACCOUNTOKEN} --accountSecret=${ACCOUNTSECRET}
```

## if an interactive session is needed for some reason...
```bash
docker run --rm -it --entrypoint="bash" ly4e/prelude-operator:latest
```

# Why these ports?
* 2323/tcp -> default (configurable) callhome-listener
* 3391/tcp -> default (configurable) webserver hosting payloads
* 4545/udp -> default (configurable)
* 8888/tcp -> default (configurable) API port 
* 8443/tcp -> required to connect to "redirector" via gui
* 50051/tcp -> required to connect to "redirector" via gui

---
---
---
## Building the image - Command Template (for reference):
```bash
VERSION=1.7.0; docker build --no-cache=true --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VERSION=$VERSION -t ly4e/prelude-operator:$VERSION -t ly4e/prelude-operator:latest  .
```
### Cherry pick the labels from docker inpect for easier review
```bash
docker inspect ly4e/prelude-operator:latest --format '{{ json .Config.Labels }}' | sed 's/,/\n/g'
```