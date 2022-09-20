/*
* REPLACE <project> WITH YOUR PROJECT NAME
* REPLACE <project-domain> WITH YOUR PROJECT DOMAIN NAME.
* REPLACE <env> WITH CURRENT ENVIRONMENT. <env> = "prd" in this case
*/ 

module "<project>-infra-frontend-static" {
  project               = "<project>"
  source                = "../../../frontend/Static"
  env                   = "<env>"
  region                = "us-east-1"
  referenceInstanceType = "t3a.medium"
  securityGroupId       = data.terraform_remote_state.<project>-infra-data.outputs.private-sg.id
  privateSubnet         = data.terraform_remote_state.<project>-infra-data.outputs.private-subnet
  amiId                 = data.terraform_remote_state.<project>-infra-data.outputs.ubuntu_ami.id
  instanceProfileName   = data.terraform_remote_state.<project>-iam-data.outputs.instance-profile.name
  jumpServerPublicKey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHblmJ+HT2KqfAIHkVzvOi1zfaLy3Lq2bmm2Rk132fL6trU+I0bn5nNvE7+I/V84SnDWPTnlP31Fbt6ryPJkea70WSSkjM89MgDVFGVWWfEbz9yNqhe+z+HXW1Tl3Fo0UxhY8kr8DiQrmZODzkHB8B1qmrUDcqsqe1i8Mvqw2SdxGTp2bcTQMnPn6cRLp4rfb3mcYjOo9vcuzvB+6a1iea/2+ZnXNTZ5FEA0pfFPUNKuCOdq9HbLOISFxUxObCVkDxMufirKAcG8MYA5lANR/8bBl5MluJABOnRuggcLVM7RFemTMBVov0T0MBPvjhS+ZwFjR+l/15xsMb61I4gsNYzuKtS9I1doFrCEJSEjOiBnzZakGlotSlTzMn8gJNE712Q68LWeraFDiN7Z9hrzKrfj5aanmUws97DXPY+CqlOvpDTNIgdNBKVKsa2wWG3SB73q3GroyHCTtgF7HGQF3afyG7rQipAjn7uiL9midekVUiBMk8ZSNuuoyBq5mY2mM= ubuntu@ip-30-0-1-187"
  part                  = "frontend"
  indexDocument         = "index.html"
  cmsSite               = "www.cms.<project-domain>.com"
}
