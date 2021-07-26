module "cryptern-infra" {
  source                 = "../"
  env                    = "dev"
  region                 = "us-east-1"
  privateSubnets         = ["10.0.0.0/24"]
  publicSubnets          = ["10.0.1.0/24"]
  jumpServerInstanceType = "t2.micro"
  publicKeyFileLocation  = "/home/zaid/.ssh/id_rsa.pub"
}
