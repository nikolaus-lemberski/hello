# Hello project

Simple Hello World project to demonstrate canary releases to Kubernetes with Github actions.

## Preparation

What you need:
1. A running Kubernetes
2. A Docker registry (Dockerhub for example)

## Setup your Github secrets

Fork the project and setup the Github secrets (> Settings > Secrets).

* DOCKER_USERNAME
* DOCKER_PASSWORD
* KUBECONFIG_SA_GITHUB

KUBECONFIG_SA_GITHUB is the config file for a serviceaccount in Kubernetes. Find instructions and a script to create the kubeconfig file in '.kubernetes/serviceaccount_config.sh'.

## Adapt the scripts

Change the image name in .github/workflows files to your Dockerhub name. Change the kubectl config to the name of your Kubernetes serviceaccount context.

## Deploy to Kubernetes

Create a new Release and name it 'v1.0.0'. The Kubernetes action "Build, push and deploy" should now start. Check the logs. After the job has finished you should have 2 pods and 1 service. Check with `kubectl get pods` and get service address with `kubectl get svc`.

Test the service by calling http get http://{serviceaddress}/hello

Now promote the release by running the Github action "Canary promote" with the Release name 'v1.0.0' as input argument.

## Deploy new release

Change the Controller text in 'src/main/java/com/lemberski/demo/hello/HelloController.java'. Add to git and push to git remote origin. Follow the steps in 'Deploy to Kubernetes' to create a new release but increase the Release version (e.g. v1.0.1). Watch the pods created during deployment `watch kubectl get pods`.

You should see new pods starting and should have 4 pods in total. One pod (name contains "canary") uses the new version and the service routes more or less Round Robin to all pods. So if you do several calls you should get 75% response from old version and 25% from new version.

Now promote the canary release again and watch the pods. After the job completes you have 2 pods with the new version.

If you're not happy with the canary version, run the "Reject canary" Github action.

