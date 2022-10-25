FROM ubuntu:22.04 AS builder
RUN apt update && apt install -y wget unzip
RUN wget "https://download.prelude.org/latest?arch=x64&platform=linux&variant=zip&edition=headless" --output-document=file.zip --output-file=file.logs
RUN cat file.logs | grep Location | cut -d/ -f 6 >> SoftwareVersion.txt
RUN unzip file.zip
RUN chmod +x headless

FROM ubuntu:22.04
# ---------------------------------------------
# Additional Required Ports - Prelude GUI Access - limit access as desired
# ---------------------------------------------
EXPOSE 50051/tcp
# TCP 50051 -> "required to connect to redirector via gui"
EXPOSE 8443/tcp
# TCP 8443 -> "required to connect to redirector via gui"

# ---------------------------------------------
# Required ports - generally open
# ---------------------------------------------
EXPOSE 2323/tcp 
# TCP 2323 (default) -> "configurable - callhome-listener"
EXPOSE 4545/udp
# UDP 4545 (default) -> "configurable - udp port"

# ---------------------------------------------
# Additional Required Ports - API and Payloads - limit access as desired
# ---------------------------------------------
EXPOSE 3391/tcp
# TCP 3391 (default) -> "configurable - webserver hosting payloads" 
EXPOSE 8888/tcp
# TCP 8888 (default) -> "configurable - API port"

# something to test later --> running as generic user <--
#RUN groupadd -r prelude && useradd --no-log-init -r -g prelude prelude

ENTRYPOINT [ "./headless" ]
CMD ["--help"]

LABEL Usage="docker run --rm -p 2323:2323/tcp -p 4545:4545/udp -p 3391:3391/tcp -p 8888:8888/tcp -p 50051:50051/tcp -p 8443:8443/tcp ly4e/prelude-operator:latest --sessionToken=\${SESSIONTOKEN} --accountEmail=\${ACCOUNTEMAIL} --accountToken=\${ACCOUNTOKEN} --accountSecret=\${ACCOUNTSECRET}"

COPY --from=builder headless .
COPY --from=builder SoftwareVersion.txt .
