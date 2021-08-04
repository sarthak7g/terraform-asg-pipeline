module "cryptern-infra-backend-autoscaling" {
    source = "../../../backend/AutoScaling"
    env ="dev"
    region= "us-east-1"
    referenceInstanceAmi = data.terraform_remote_state.cryptern-static-backend-data.outputs.reference-instance-backend.id
}