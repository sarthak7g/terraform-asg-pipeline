module "cryptern-infra" {
  source                 = "../"
  env                    = "dev"
  region                 = "us-east-1"
  availabilityZones      = ["us-east-1a", "us-east-1b"]
  privateSubnets         = ["10.0.0.0/24", "10.0.2.0/24"]
  publicSubnets          = ["10.0.1.0/24", "10.0.3.0/24"]
  jumpServerInstanceType = "t2.micro"
  publicKey              = file("/home/zaid/.ssh/id_rsa.pub")
}
