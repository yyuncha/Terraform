module "iam_policy" {
    source                  = "./modules/iam_policy"
    iam_policy              = var.iam_policy
    iam_policy_json         = var.iam_policy_json
}

module "iam_role" {
    source              = "./modules/iam_role"
    iam_role            = var.iam_role
    assume_role_policy  = var.assume_role_policy
    iam_role_policy     = var.iam_role_policy
}