# Terraform talk

This talk was given at the 11/20/2021 Penguins Unbound Linux User group meeting.

View the presentation in the `terraform-talk.pdf` file.

If it doesn't exist generate it:

```
texi2pdf presentation/main.tex
```

## View demos

Each demo has a README go look at those:

* [DNS](./examples-demos/dns/README.md)
  * A very simple real world example.
* [Dominos](./examples-demos/dominos/README.md)
  * An interesting example to explain terraform components, and order pizza.
* [GKE](./examples-demos/gke/README.md)
  * A big example showing modules and consuming other public terraform.
* [libvirt](./examples-demos/libvirt/README.md)
  * The provider us linux nerds live for.
* [cert-manager](./examples-demos/cert-manager/README.md)
  * Nice example showing complex IAM policy work and shipping the results to kuberentes.


```
└── examples-demos
    ├── cert-manager
    │   ├── main.tf
    │   └── README.md
    ├── dns
    │   ├── main.tf
    │   └── README.md
    ├── dominos
    │   ├── main.tf
    │   └── README.md
    ├── gke
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── README.md
    │   └── variables.tf
    └── libvirt
        ├── cloud_init.cfg
        ├── network_config.cfg
        ├── README.md
        └── ubuntu-example.tf
```
