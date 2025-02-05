data "aws_caller_identity" "customer" {}
resource "aws_ecr_repository" "customer" {
  name = "customer-repo"
    tags = {
        Name = "customer-repo"
    } 
}
data "aws_iam_policy_document" "example" {
  statement {
    sid    = "DenyPull"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.bastion.arn}"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
}

resource "aws_ecr_repository_policy" "example" {
  repository = aws_ecr_repository.customer.name
  policy     = data.aws_iam_policy_document.example.json
}

resource "aws_ecr_repository" "Product" {
  name = "product-repo"
    tags = {
        Name = "hrdkorea-ecr-repo"
    } 
}
resource "aws_ecr_repository" "order" {
  name = "order-repo"
    tags = {
        Name = "order-repo"
    } 
}