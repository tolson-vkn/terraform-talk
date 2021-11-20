# Libvirt

This example pulled directly from: https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.13/ubuntu/ubuntu-example.tf

I have also added some `runcmd` to the cloud init:

```
runcmd:
  - apt-get update && apt-get install --no-install-recommends -y nginx
  - systemctl enable nginx
  - systemctl start nginx
```

This makes it launch an nginx web server.

This is fine but you'd be better of trying to use the qemu packer tooling: https://www.packer.io/docs/builders/qemu
