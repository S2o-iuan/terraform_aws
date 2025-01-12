#user
resource "aws_iam_user" "user" {
  name = var.iam_user_name
  tags = {
    Name = var.iam_user_name
  }
}

#userをgroupに追加
resource "aws_iam_user_group_membership" "iam_user_group_membership" {
  count = var.iam_user_group_membership == true ? 1 : 0
  user  = aws_iam_user.user.id
  groups = [
    "${var.iam_group_name}"
  ]
}