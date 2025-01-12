# IAMロール作成
resource "aws_iam_role" "iam_role" {
  for_each           = var.iam_role
  name               = each.key
  assume_role_policy = each.value
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_iam_policy" "iam_role_policy" {
  for_each = var.iam_role_policy
  name     = each.key
  policy   = each.value
  tags = {
    Name = "${each.key}"
  }  
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attach" {
  for_each           = var.iam_role_policy_attach
  role               = each.key
  policy_arn         = aws_iam_policy.iam_role_policy[each.value].arn
  depends_on         = [aws_iam_role.iam_role, aws_iam_policy.iam_role_policy]
}

# 複数のポリシーアタッチ用
resource "aws_iam_role_policy_attachment" "iam_role_policy_attach_more" {
  for_each   = toset(var.policy_attach_more)
  role       = var.iam_role_name
  policy_arn = each.key
  depends_on = [aws_iam_role.iam_role, aws_iam_policy.iam_role_policy]
}

# マネージドポリシーアタッチ用
resource "aws_iam_role_policy_attachment" "iam_role_policy_attach_maneged" {
  for_each   = toset(var.maneged_policy)
  role       = var.iam_role_name
  policy_arn = each.key
  depends_on = [aws_iam_role.iam_role]
}