terraform {
  backend "s3" {
    bucket               = "ascode-terraform"
    key                  = "test/ascode_test.tfstate"
    region               = "eu-central-1"
    encrypt              = true
    workspace_key_prefix = "ascode_test"
    dynamodb_table       = "tf-state-lock"
  }
}
