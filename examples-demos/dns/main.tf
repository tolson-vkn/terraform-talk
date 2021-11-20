provider "aws" {
  region = "us-east-1"
}

locals {
  ip_main = lookup({
    dev  = "8.8.8.8",
    prod = "1.1.1.1"
  }, terraform.workspace)

  ip_failover = lookup({
    dev  = "9.9.9.9",
    prod = "2.2.2.2"
  }, terraform.workspace)

  dns_name = lookup({
    dev  = "coolapp-dev",
    prod = "coolapp"
  }, terraform.workspace)
}

data "aws_route53_zone" "tolson-io" {
  name         = "tolson.io"
  private_zone = false
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.tolson-io.zone_id
  name    = "${local.dns_name}.${data.aws_route53_zone.tolson-io.name}"
  type    = "A"
  ttl     = "60"
  records = [local.ip_main]

  set_identifier = local.dns_name

  weighted_routing_policy {
    weight = 100
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
    weight = 0
  }
}

