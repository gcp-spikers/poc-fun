# README Please

This is 5 samples app, from the [ISTIO sample apps](https://istio.io/docs/guides/bookinfo/)

## TODO

1. Hook up to cloud build with Vulnerability Scanning Alpha feature enable (Terraform cloud build config)
1. Update the Container Analysis API once the Vulnerability Scanning Passed.
1. Spin UP GKE (terraform)
1. Install Spinaker (Halyard)
1. Spin up GKE in a different Project (terraform)
1. Configure Spinaker to deploy to the newly created GKE (DCD or something else)
1. Use binary Authorization to make sure we can deploy the container
1. Write Deploy metadata to Grafeas

## Test Cloud Build locally

```
$ cloud-build-local --config=cloudbuild.yaml --dryrun=false --push=false .
```
