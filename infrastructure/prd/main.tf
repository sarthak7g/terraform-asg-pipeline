/*
* ACTIONS-
*   1) REPLACE <project> WITH YOUR PROJECT NAME
* 
* OTHER INSTRUCTIONS-
*   1) YOU CAN HAVE MULTIPLE ENVIRONMENTS LIKE {"dev", "prd", "stg",...}.
*   2) WE FOLLOW THIS CONVENTION OF GIVING SAME NAME AS ENVIRONMENT TO THE PARENT FOLDER
*/ 

module "<project>-infra" {            
  source                 = "../"
  env                    = "prd"    // <env> = prd
  project                = "<project>"
  region                 = "us-east-1"
  availabilityZones      = ["us-east-1a", "us-east-1b"]
  privateSubnets         = ["30.0.0.0/24", "30.0.2.0/24"]
  publicSubnets          = ["30.0.1.0/24", "30.0.3.0/24"]
  jumpServerInstanceType = "t2.micro"
  publicKey              = file("/home/zaid/.ssh/id_rsa.pub")
  vpcCidrBlock           = "30.0.0.0/16"
}
