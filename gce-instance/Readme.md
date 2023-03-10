# About this folder

This folder contains a simple Terraform configuration that creates an instance of Google Cloud Compute Engine (e2.micro)

## How to run this configuration

### Prerequisites

0. Create a Google Cloud account
1. Create a ssh key pair (public and private key. <b>NOTE: while generating your ssh keys, DO NOT insert a passowrd </b>)
2. Google Cloud CLI tools. You need to [login via CLI](https://cloud.google.com/sdk/gcloud/reference/auth/application-default) in order to interact with your account
3. Terraform installed on your machine
4. Clone this repo

### Run

1. Go inside this folder <code>cd gce-instance</code>
2. Open <code>terraform.tfvars</code> file with your favorite text editor and change <code>gce_ssh_user</code> <code>gce_ssh_pub_key_file</code> <code>project</code> <code>region</code> <code>zone</code> values
3. Execute <code>terraform init</code>
4. Execute <code>terraform fmt</code>
5. Execute <code>terraform apply</code>

After doing this, go back to your Google Cloud's VMs dashboard and watch your VM instance getting created <br>

If you want to destory your VM, execute <code>terraform destory</code>
