resource "aws_security_group" "prod-cluster" {
  name        = "eks-prod-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-prod"
  }
}

resource "aws_security_group_rule" "prod-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prod-cluster.id
  source_security_group_id = aws_security_group.prod-node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "prod-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.prod-cluster.id
  to_port           = 443
  type              = "ingress"
}
