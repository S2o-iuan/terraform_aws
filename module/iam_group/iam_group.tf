#group
resource "aws_iam_group" "iam_group" {
  name = var.iam_group_name
}

#group_policyをgroupにアタッチ
resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  for_each   = toset(var.group_policy_attach)
  group      = aws_iam_group.iam_group.id
  policy_arn = each.key
  }