 locals{ 
 test = {
    iam_role_name             = "common02_bakutest"
    iam_role                  = {common02_bakutest = file("./common02.json"),}
    iam_role_policy           = {bakutest = file("./iampl-prd-biz-logs_put_retention01.json"),
                                bakutest3= file("./iampl-prd-biz-s3_putruncommandresult01.json")}
    iam_role_policy_attach    = ["arn:aws:iam::xxxxxxxxx:policy/bakutest3,
                                 "arn:aws:iam::xxxxxxxxx:policy/bakutest"]
    maneged_policy            = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
                                 "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
 }

 test2 = {
    iam_role_name             = "common02_bakutest2"
    iam_role                  = {common02_bakutest2 = file("./common02.json"),}
    iam_role_policy           = {bakutest2 = file("./iampl-prd-biz-logs_put_retention01.json"),
                                bakutest3 = file("./iampl-prd-biz-s3_putruncommandresult01.json")}
    iam_role_policy_attach    = ["arn:aws:iam::xxxxxxxxx:policy/bakutest3",
                                 "arn:aws:iam::xxxxxxxxx:policy/bakutest2"]
    maneged_policy            = []
 }
   
  test3 = {
    iam_role_name             = "import_test"
    iam_role                  = {import_test = file("./common02.json"),}
    iam_role_policy           = {}
    iam_role_policy_attach    = ["arn:aws:iam::xxxxxxxxx:policy/bakutest2",
                                 "arn:aws:iam::xxxxxxxxx:policy/bakutest"]
    maneged_policy            = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
 }
}

module "common02" {
    source = "./module/iam"
    
    iam_role_name           = local.test.iam_role_name
    iam_role                = local.test.iam_role
    iam_role_policy         = local.test.iam_role_policy
    iam_role_policy_attach  = local.test.iam_role_policy_attach
    maneged_policy          = local.test.maneged_policy
}

module "common02_2" {
    source = "./module/iam"
    
    iam_role_name           = local.test2.iam_role_name
    iam_role                = local.test2.iam_role
    iam_role_policy         = local.test2.iam_role_policy
    iam_role_policy_attach  = local.test2.iam_role_policy_attach
    maneged_policy          = local.test2.maneged_policy
}

module "common02_3" {
    source = "./module/iam"
    
    iam_role_name           = local.test3.iam_role_name
    iam_role                = local.test3.iam_role
    iam_role_policy         = local.test3.iam_role_policy
    iam_role_policy_attach  = local.test3.iam_role_policy_attach
    maneged_policy          = local.test3.maneged_policy
}