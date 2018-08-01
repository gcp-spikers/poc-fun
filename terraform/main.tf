provider "google" {
  region      = "${var.region}"
  credentials = "credentials.json"
}

terraform {
  backend "gcs" {
    credentials = "credentials.json"
    region      = "australia-southeast1"
  }
}

module "kube-cluster" {
  source  = "modules/kube-cluster"
  project = "${var.project}"
}
