resource "aws_eks_cluster" "prod" {
  name     = var.cluster-name
  role_arn = aws_iam_role.prod-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.prod-cluster.id]
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.prod-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.prod-cluster-AmazonEKSServicePolicy,
  ]
}
