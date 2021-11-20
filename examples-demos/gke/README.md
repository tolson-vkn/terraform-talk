# GKE Public Cluster

## Taken from

https://github.com/gruntwork-io/terraform-google-gke/tree/master/examples/gke-public-cluster

I didn't have a current GKE example so I found this one. This could work pretty well for you, it seems nice
I do/would however caution just grabbing someone else's TF especially for learning. You might want to try
doing this yourself.

## How do you run these examples?

1. Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) v0.14.8 or later.
1. Open `variables.tf`, and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
1. To setup `kubectl` to access the deployed cluster, run `gcloud beta container clusters get-credentials $CLUSTER_NAME
--region $REGION --project $PROJECT`, where `CLUSTER_NAME`, `REGION` and `PROJECT` correspond to what you set for the
input variables.
