resource "aws_s3_bucket" "tf_bucket" {
  bucket = "ascode-terraform-code"
  acl = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.s3_key_id}"
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags {
    Name = "ascode-terraform-code"
    ResourceContact = "${var.resource_contact}"
  }
}

resource "aws_s3_bucket_policy" "tf_bucket_policy" {
  bucket = "${aws_s3_bucket.tf_bucket.id}"
  policy = "{data.aws_iam_policy_document.bucketencryptionpolicy.json}"
}

resource "aws_s3_bucket" "cf_bucket" {
  bucket = "ascode-cloudformation-code"
  acl = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.s3_key_id}"
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags {
    Name = "ascode-cloudformation-code"
    ResourceContact = "${var.resource_contact}"
  }
}

resource "aws_s3_bucket_policy" "cf_bucket_policy" {
  bucket = "${aws_s3_bucket.cf_bucket.id}"
  policy = "{data.aws_iam_policy_document.bucketencryptionpolicy.json}"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "ascode-data-bucket"
  acl = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.s3_key_id}"
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags {
    Name = "ascode-databucket"
    ResourceContact = "${var.resource_contact}"
  }
}

resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = "${aws_s3_bucket.data_bucket.id}"
  policy = "{data.aws_iam_policy_document.bucketencryptionpolicy.json}"
}
