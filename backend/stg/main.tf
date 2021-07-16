module "remote-state" {
  source = "../../"
  env    = "stg"
  region = "us-east-1"
}
