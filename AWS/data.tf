#provider "aws" {
#  assume_role {
#        role_arn = "arn:aws:iam::${var.aws_account_number}:role/${var.aws_accelerator_role}"
#    }
#  region     = "${var.aws_region}"
  #shared_credentials_file = "c:\users/ldrnoe1/.aws/credentials"
  #profile = "accelerator"
#}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_kms_alias" "kms_ebs" {
  name = "alias/AGT-${lookup(var.environment_full, upper(var.environment))}-EBS"
}

data "aws_vpc" "vpc1" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "priv1" {
  id = "${var.subnet_priv1}"
}

data "aws_subnet" "priv2" {
  id = "${var.subnet_priv2}"
}

data "aws_kms_key" "rdskey" {
  key_id = "${var.rds_key_id}"
}

data "template_file" "user_data" {
  template = "$file("linux_user_data.tpl")"
}

data "aws_iam_policy_document" "deny_policy" {
  statement {
    effect = "Deny"

    actions = [
      "ec2:AcceptVpcPeeringConnection",
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "ec2:AssociateDhcpOptions",
      "ec2:AssociateRouteTable",
      "ec2:AssociateSubnetCidrBlock",
      "ec2:AssociateVpcCidrBlock",
      "ec2:AttachClassicLinkVpc",
      "ec2:AttachInternetGateway",
      "ec2:AttachVpnGateway",
      "ec2:CreateCustomerGateway",
      "ec2:CreateDhcpOptions",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateFlowLogs",
      "ec2:CreateNatGateway",
      "ec2:CreateVpc*",
      "ec2:CreateVpn*",
      "ec2:CreateInternetGateway",
      "ec2:CreateNetworkAcl",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:CreateVpcEndpoint",
      "ec2:CreateVpcPeeringConnection",
      "ec2:CreateVpnConnection",
      "ec2:CreateVpnConnectionRoute",
      "ec2:CreateVpnGateway",
      "ec2:DeleteCustomerGateway",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteEgressOnlyInternetGateway",
      "ec2:DeleteFlowLogs",
      "ec2:DeleteNatGateway",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSubnet",
      "ec2:DeleteVpc*",
      "ec2:DeleteVpn*",
      "ec2:DetachClassicLinkVpc",
      "ec2:DetachInternetGateway",
      "ec2:DetachVpnGateway",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DisableVpcClassicLink",
      "ec2:DisassociateAddress",
      "ec2:DisassociateRouteTable",
      "ec2:DisassociateSubnetCidrBlock",
      "ec2:DisassociateVpcCidrBlock",
      "ec2:EnableVgwRoutePropagation",
      "ec2:EnableVpcClassicLink*",
      "ec2:ModifyIdentityIdFormat",
      "ec2:ModifyIdFormat",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpc*",
      "ec2:MoveAddressTovPC",
      "ec2:RejectVpcPeeringConnection",
      "ec2:ReleaseAddress",
      "ec2:ReplaceNetwork*",
      "ec2:ReplaceRoute*",
      "ec2:RestoreAddressToClassic",
      "iam:CreateAccountAlias",
      "iam:CreateSAMLProvider",
      "iam:CreateVirtualMFADevice",
      "iam:DeactivateMFADevice",
      "iam:DeleteAccountAlias",
      "iam:DeleteAccountPasswordPolicy",
      "iam:DeleteSAMLProvider",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetAccountAuthorizationDetails",
      "iam:ResyncMFADevice",
      "iam:UpdateAccountPasswordPolicy",
      "iam:UpdateSAMLProvider",
      "iam:Delete*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "devboxrolepolicy" {
  statement {
    sid = "FullAdminAccess"
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }

  statement {
    sid = "EC2RunInstancesEncryptedAMIOnly"
    effect = "Allow"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:${var.aws_account_id}::image/ami-*"
    ]
    condition {
      test = "StringLike"
      variable = "ec2:ResourceTag/Encrypted"
      values = 'TRUE'
    }
  }
}

data "aws_iam_policy_document" "bucketencryptionpolicy" {
  statement {
    sid = "DenyIncorrectEncryptionHeader"
    effect = "Deny"
    Principal = "*"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tf_bucket.id}/*"
    ]
    condition {
       test = "StringNotEquals"
       variable = "s3:x-amz-server-side-encryption"
       values = [
         "AES256"
        ]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    Principal = "*"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tf_bucket.id}/*"
    ]
    condition {
       test = "Null"
       variable = "s3:x-amz-server-side-encryption"
       values = [
         "true"
        ]
    }
  }

  statement {
    sid = "AllowS3ToRole"
    effect = "Allow"
    Principal = "*"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tf_bucket.id}/*"
    ]
    principals {
			type = "AWS"
			identifiers = ["${lookup(var.KMSAccessArns, var.environment}"]
		}
  }

  statement {
    sid = "DenyS3ToRole"
    effect = "Deny"
    Principal = "*"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.tf_bucket.id}"
    ]
    principals {
			type = "AWS"
			identifiers = ["${lookup(var.KMSDenyArns, var.environment}"]
		}
  }
}

data "aws_iam_policy_document" "devbox-assume-role-policy" {
  statement {
    sid = "SAML"
    effect = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:saml-provider/AGT"]
    }
    condition {
       test = "StringEquals"
       variable = "SAML:aud"
       values = [
         "https://signin.aws.amazon.com/saml"
        ]
  }

  statement {
    sid = "EC2"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid = "root"
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
  }

  statement {
    sid = "FullAdminAccess"
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }

  statement {
    sid = "EC2RunInstancesEncryptedAMIOnly"
    effect = "Allow"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:${var.aws_account_id}::image/ami-*"
    ]
    condition {
      test = "StringLike"
      variable = "ec2:ResourceTag/Encrypted"
      values = 'TRUE'
    }
  }
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
