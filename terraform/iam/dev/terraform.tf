terraform {
    required_version = "1.0.2"
    backend "s3" {
      bucket = "terraform-main-state.cryptern.dev"
      key = "iam-cryptern.tfstate"
      
    }
}
