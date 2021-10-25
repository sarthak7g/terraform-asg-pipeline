# Steps
1. Terraform Backend:- Create a bucket and dynamoDb for terraform backend handling
2. IAM 
    a. Create IAM for specific environments
1. VPC setup
2. ssh on jump server and Create ssh key
3. Static Infra setup (pass ssh key of jump server)
4. Verify Installation
5. DGOKKg7brZRmW3NN
crypterns-backend
mongodb+srv://crypterns-backend:<password>@cluster0.lhjic.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
Replace <password> with the password for the crypterns-backend user. Replace myFirstDatabase with the name of the database that connections will use by default. Ensure any option params are URL encoded.
5. Run app on reference instance
    **Use root user for all the operation**
    $ sudo su -
    $ cd /home/ubuntu
    **For backend**
        a. In  "/etc/nginx/nginx.conf"  Add
                http {
                    client_max_body_size 10M;

                    //other lines...
                }
        b. service nginx restart
        c. Edit configuration files in conf.d
        d. service nginx reload
        e. Git clone the repo adn deploy environment specific branch
        f. run the app
        g. run pm2 startup
    **For frontend**
        a. Git clone the repo adn deploy environment specific branch
        b. run the app
        c. run pm2 startup
6. Create Autoscaling groups for frontend and backend
7. Check Health status for target groups
8. You can check logs for code deploy --> /opt/codedeploy-agent/deployment-root/deployment-logs
9. Create AWS CICD from deploymnet folder for frontend and backend
10. Gitlab CI/CD setup

# VPC

A VPC with a size /16 IPv4 CIDR block (example: 10.0.0.0/16). This provides 65,536 private IPv4 addresses.

## Subnet

1. For now we have taken one availability zone, Based on availability zones private subnet and private subnet CIDR blocks should be passed.
2. Each avaialbility zone should have its own private subnet and public subnet
3. We do not map public Ip on launch for private subnet resources since there will be no incoming traffic from outside the VPC
4. A public subnet with a size /24 IPv4 CIDR block (example: 10.0.0.0/24). This provides 256 private IPv4 addresses. A public subnet is a subnet that's associated with a route table that has a route to an internet gateway.
5. A private subnet with a size /24 IPv4 CIDR block (example: 10.0.1.0/24). This provides 256 private IPv4 addresses.

## Internet gateway

An internet gateway. This connects the VPC to the internet and to other AWS services.

1. Instances with private IPv4 addresses in the subnet range (examples: 10.0.0.5, 10.0.1.5). This enables them to communicate with each other and other instances in the VPC.
2. Instances in the public subnet with Elastic IPv4 addresses (example: 198.51.100.1), which are public IPv4 addresses that enable them to be reached from the internet. The instances can have public IP addresses assigned at launch instead of Elastic IP addresses. Instances in the private subnet are back-end servers that don't need to accept incoming traffic from the internet and therefore do not have public IP addresses; however, they can send requests to the internet using the NAT gateway

## NAT

A NAT gateway with its own Elastic IPv4 address. Instances in the private subnet can send requests to the internet through the NAT gateway over IPv4 (for example, for software updates).

1. Connectivity type should be public, Instances in private subnets can connect to the internet through a public NAT gateway, but cannot receive unsolicited inbound connections from the internet.
2. It has to be in a public subnet

## Route table

1. A route table associated with the public subnet. This route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate directly with the internet over IPv4.
2. A route table associated with the private subnet. The route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate with the internet through the NAT gateway over IPv4.
3. Do not need to provide aws_route resource for local routing it is handled by default

## Security group

1. Private security group -- Only allow inbound traffic from Public security group resources. Allow all outbound traffic
2. Public security group --- Allow traffic from all

## ALB

Requires minimum two subnets in two differet availibility zones

# Deployment

# AWS CodePipeline

## AWS CodeDeploy

AWS CodeDeploy allows us to integrate software deployment and scaling activities in order to keep our application up-to-date in a dynamic production environment. For Amazon EC2 instances, CodeDeploy integrates with Auto Scaling. Auto Scaling allows us to scale EC2 capacity according to conditions we define such as spikes in traffic. CodeDeploy is notified whenever a new instance launches into an Auto Scaling group and will automatically perform an application deployment on the new instance before it is added to an Elastic Load Balancing load balancer.


https://docs.aws.amazon.com/autoscaling/ec2/userguide/images/auto_scaling_lifecycle.png