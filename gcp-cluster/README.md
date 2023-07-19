# GCP cluster

This folder contains a Terraform configuration that I used to create a Compute Engine cluster on GCP

## How to run this configuration

Create a .tfvars file (you can find an example in <code>vars-example</code> file) and add your variables using the values that you prefer

**_NOTE:_** by choice some values are hardcoded (such as VMs count in <code>main.tf</code> and some other configurations in <code>modules/vm/main.tf</code>), be sure to modify these parameters accordingly

After changing the values in your file, run the follwing commnands:

<code>terraform fmt</code>

<code>terraform init</code>

<code>terraform plan</code>

<code>terraform apply</code>

If you want to destory all the infrastructure that you created, run:

<code>terraform destory</code>
