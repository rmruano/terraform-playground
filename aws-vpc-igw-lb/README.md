# Sample AWS VPC provisioning with load balancer

Creates a sample VPC with 2 subnets in different availability zones and one instance on each one.  

Instances have full egress internet access but only public ingress to port 22.

A public load balancer provides connectivity to 2 nginx instances which expose the 80 port only to the vpc.

----------

Please provide a public key for your instances:

If you don't have one:
`ssh-keygen -b 4096 -t rsa -f /home/you/.ssh/id_rsa -q -N ""`

Import it to your aws zone (will fail if it already exists)
`aws ec2 import-key-pair --key-name "key" --public-key-material fileb:///home/you/.ssh/id_rsa.pub --region=eu-west-2`

The terraform `keypair_name` variable is sensitive and will be asked if it's not specified in a .tfvars file or through the ENV var `TF_VAR_keypair_name`

Connecting to your instances:

They have the public 22 port open, use your private key, the bitnami user and the instance public ip returned in the output.
`ssh -i /home/you/.ssh/id_rsa bitnami@0.0.0.0`