locals {
  iam_group = {
    iam_group_name      = "iam_group"
    group_policy_attach = ["arn:aws:iam::942014761786:policy/2129172-test"]
  }
  iam_user = {
    iam_user_name             = "iam_user"
    iam_user_group_membership = true
    iam_group_name            = "iam_group"
  }
}

module "iam_group" {
  source = "./module/iam_group"

  iam_group_name      = local.iam_group.iam_group_name
  group_policy_attach = local.iam_group.group_policy_attach
}
module "iam_user" {
  source = "./module/iam_user"

  iam_user_name             = local.iam_user.iam_user_name
  iam_user_group_membership = local.iam_user.iam_user_group_membership
  iam_group_name            = local.iam_user.iam_group_name
}