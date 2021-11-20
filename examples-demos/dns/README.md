# DNS

This is a very basic example of how to use terraform to manage DNS. It is somewhat interesting in that
it uses weights. This can be useful in demoing creation and change sets:

This uses workspaces which is a great way to segment environments:

```
terraform.tfstate.d
    ├── dev
    │   ├── terraform.tfstate
    │   └── terraform.tfstate.backup
    └── prod
        ├── terraform.tfstate
        └── terraform.tfstate.backup
```

## Create

```
# Make the dev workspace to get lookups working
terraform workspace new dev
terraform init
```

## Run

```
terraform plan
```

Output:

```
❯ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_route53_record.failover will be created
  + resource "aws_route53_record" "failover" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "coolapp-dev.tolson.io"
      + records         = [
          + "9.9.9.9",
        ]
      + set_identifier  = "coolapp-dev-failover"
      + ttl             = 60
      + type            = "A"
      + zone_id         = "Z0067177EZMPO58VJQVN"

      + weighted_routing_policy {
          + weight = 0
        }
    }

  # aws_route53_record.main will be created
  + resource "aws_route53_record" "main" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "coolapp-dev.tolson.io"
      + records         = [
          + "8.8.8.8",
        ]
      + set_identifier  = "coolapp-dev"
      + ttl             = 60
      + type            = "A"
      + zone_id         = "Z0067177EZMPO58VJQVN"

      + weighted_routing_policy {
          + weight = 100
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

```
terraform apply
```

And woot!

## Test it

```
watch -n 5 dig +noall +answer @ns-30.awsdns-03.com coolapp-dev.tolson.io
```

Note these dns name and name servers are unique to me, you'd have to change this to your setup if running this demo

Example output:

```
coolapp-dev.tolson.io.  60      IN      A       8.8.8.8
```

## Example changeset:

My changes:

``` diff
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.tolson-io.zone_id
  name    = "${local.dns_name}.${data.aws_route53_zone.tolson-io.name}"
  type    = "A"
  ttl     = "60"
  records = [local.ip_main]

  set_identifier = local.dns_name

  weighted_routing_policy {
-   weight = 100
+   weight = 0
  }
}

resource "aws_route53_record" "failover" {
  zone_id = data.aws_route53_zone.tolson-io.zone_id
  name    = "${local.dns_name}.${data.aws_route53_zone.tolson-io.name}"
  type    = "A"
  ttl     = "60"
  records = [local.ip_failover]

  set_identifier = "${local.dns_name}-failover"

  weighted_routing_policy {
-   weight = 0
+   weight = 100
  }
}
```

Results in this plan:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_route53_record.failover will be updated in-place
  ~ resource "aws_route53_record" "failover" {
        id             = "Z0067177EZMPO58VJQVN_coolapp-dev.tolson.io_A_coolapp-dev-failover"
        name           = "coolapp-dev.tolson.io"
        # (6 unchanged attributes hidden)

      ~ weighted_routing_policy {
          ~ weight = 0 -> 100
        }
    }

  # aws_route53_record.main will be updated in-place
  ~ resource "aws_route53_record" "main" {
        id             = "Z0067177EZMPO58VJQVN_coolapp-dev.tolson.io_A_coolapp-dev"
        name           = "coolapp-dev.tolson.io"
        # (6 unchanged attributes hidden)

      ~ weighted_routing_policy {
          ~ weight = 100 -> 0
        }
    }

Plan: 0 to add, 2 to change, 0 to destroy.
```

NICE!


