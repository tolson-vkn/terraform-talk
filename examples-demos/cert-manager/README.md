# Cert Manager

This is a cool use of terraform to create the required infra to do Let's Encrypt certificates.

What is nice is it use the AWS provider and a Kubernetes provider.

It sets it up so that I can create user who can satisfy Let's Encrypt dns01 challenges, but also transports the service account users secret to kuberentes. Which is used on each cert-manager issuer resource.

The secret generated looks like (this is used by the below kube tooling, but deployed by terraform):

```
apiVersion: v1
kind: Secret
metadata:
  managedFields:
  - apiVersion: v1
    manager: HashiCorp
    operation: Update
  name: tolson-io-issuer-secret
  namespace: cert-manager
type: Opaque
data:
  secret-access-key: WU9VV0lTSC1USElTSVNBU0VDUkVUS0VZVVNVQUxMWQ==
```

The cluster issuer looks like (this get's deployed by kube tooling, not terraform:

```
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: tolson-io-issuer-prod
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: REDACTED

    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt

    solvers:
    - selector:
        dnsZones:
          - "tolson.io"
      dns01:
        route53:
          region: us-east-1
          accessKeyID: REDACTED
          secretAccessKeySecretRef:
            name: tolson-io-issuer-secret
            key: secret-access-key
```
