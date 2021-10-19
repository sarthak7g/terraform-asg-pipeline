module "cryptern-infra" {
  source                 = "../"
  env                    = "prd"
  region                 = "us-east-1"
  availabilityZones      = ["us-east-1a", "us-east-1b"]
  privateSubnets         = ["30.0.0.0/24", "30.0.2.0/24"]
  publicSubnets          = ["30.0.1.0/24", "30.0.3.0/24"]
  jumpServerInstanceType = "t2.micro"
  publicKey              = file("/home/zaid/.ssh/id_rsa.pub")
  vpcCidrBlock           = "30.0.0.0/16"
}
