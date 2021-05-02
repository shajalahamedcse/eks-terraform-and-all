# IaC codes for launching EKS Cluster

## Installation and Configuration of the Cluster
> Create an S3 bucket named 'terraform-state-store' from AWS Console and DynamoDB Table named 'terraform_locks' with key **LockID** and put the info in **providers.tf** file

Configure AWS CLI 
```bash
$ aws configure
```
Go to the iac directory
```bash
$ cd iac
```
Initialize terraform in iac directory
```bash
$ terraform init
```
Plan the EKS cluster
```bash
$ terraform plan
```
Deploy the infra
```bash
$ terraform apply
```
When prompted for approval, type **yes**

Upon successful completion of cluster creation, now it's time for configuring the **kubectl**. Save the output in **~/.kube/config**
```bash
$ terraform output kubeconfig >> ~/.kube/config
# Edit and trim the first and last line(containing <<EOT) from ~/.kube/config
$ vim ~/.kube/config
$ aws eks --region ap-southeast-1 update-kubeconfig --name eks-prod
```

Configure AWS config maps for accessing the nodes
```bash
$ terraform output config-map-aws-auth >> config-map-aws-auth.yaml
# Edit and trim the first and last line(containing <<EOT) from config-map-aws-auth.yaml
$ vim config-map-aws-auth.yaml
$ kubectl apply -f config-map-aws-auth.yaml
```
Now do **kubectl get nodes -w** to see the nodes coming up

## Install AWS LB Controller for provisioning ingress with ALB
1. Follow the instructions from https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html to provision LoadBalancer Controller

Check if the LB Controller is available by runnint **kubectl get deployment -n kube-system aws-load-balancer-controller**


## How to use a Network Load Balancer with the NGINX Ingress resource in Kubernetes
Start by creating the mandatory resources for NGINX Ingress in your cluster:

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml