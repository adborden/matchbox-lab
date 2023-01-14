# matchbox-lab

Dynamic iPXE boot configurations for the lab.


## Development

### Requirements

- docker


### Commands

    $ make build


## Deploy

Push configuration to matchbox server.

    $ make deploy

Update assets with latest flatcar images.

    $ make update

_TODO: add this via ansible. adborden/matchbox is built for armv7 (raspberry
pi)._

```
[Unit]
Description=Matchbox iPXE, Ignition, and boot configuration service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
#ExecStartPre=/usr/bin/docker pull quay.io/poseidon/matchbox:latest
ExecStart=/usr/bin/docker run --rm -p 8080:8080 -v /var/lib/matchbox:/var/lib/matchbox:Z --name %n adborden/matchbox:latest -address=0.0.0.0:8080  -log-level=debug

[Install]
WantedBy=multi-user.target
```

### TFTP

My dd-wrt router includes dnsmasq, but not compiled for TFTP. We run the TFTP
server from matchbox.


Install packages:
- dnsmasq
- ipxe

```
# /etc/dnsmasq.d/tftp.conf
enable-tftp
tftp-root=/usr/lib/ipxe
```

TODO: enable firewall to disable DHCP/DNS, we don't want it accidentally serving
addresses.

## Generating self-signed certificates

Client certificate.

    $ bin/cfssl gencert -ca=secrets/certificates/ca.pem -ca-key=secrets/certificates/ca-key.pem -config=certificates/ca-config.json -profile=client certificates/client.json | bin/cfssljson -bare secrets/certificates/client

Server certificate.

    $ bin/cfssl gencert -ca=secrets/certificates/ca.pem -ca-key=secrets/certificates/ca-key.pem -config=certificates/ca-config.json -profile=server certificates/server.json | bin/cfssljson -bare secrets/certificates/server

Peer certificates.

    $ bin/cfssl gencert -ca=secrets/certificates/ca.pem -ca-key=secrets/certificates/ca-key.pem -config=certificates/ca-config.json -profile=member certificates/member.json | bin/cfssljson -bare secrets/certificates/member


## References

- [Matchbox](https://matchbox.psdn.io/)
- [Tutorial: Install a Highly Available K3s Cluster at the Edge - The New Stack](https://thenewstack.io/tutorial-install-a-highly-available-k3s-cluster-at-the-edge/)
