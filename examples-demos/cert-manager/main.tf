# It would probably be smart to remove my domain from the resource names
# but this was never intended to be public.

provider "aws" {
  region  = "us-east-1"
}

provider "kubernetes" {
}

# Here we can assume I put this zone in route53 in some other automation.
# This value is interpolated and injected in the policy.
data "aws_route53_zone" "tolson-io" {
  name         = "tolson.io"
  private_zone = false
}

resource "aws_iam_policy" "cert-manager-policy" {
  name = "cert-manager-policy"

  description = "cert-manager iam policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/${data.aws_route53_zone.tolson-io.zone}"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "cert-manager" {
  name = "cert-manager"
  path = "/k8s/"
}

resource "aws_iam_user_policy_attachment" "cert-manager-policy-attachment" {
  user       = aws_iam_user.cert-manager.name
  policy_arn = aws_iam_policy.cert-manager-policy.arn
}

resource "aws_iam_access_key" "access-key" {
  user = aws_iam_user.cert-manager.name
}

resource "kubernetes_secret" "tolson-io-secret" {
  metadata {
    name = "tolson-io-issuer-secret"
    namespace = "cert-manager"
  }
  data = {
    "secret-access-key" = aws_iam_access_key.access-key.secret
  }
}
