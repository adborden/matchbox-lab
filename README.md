# matchbox-lab

Dynamic iPXE boot configurations for the lab.


## Deploy

    $ ssh matchbox.lab


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

## References

- [Matchbox](https://matchbox.psdn.io/matchbox/)
