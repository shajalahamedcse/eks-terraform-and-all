data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.prod.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

locals {
  prod-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.prod.endpoint}' --b64-cluster-ca '${aws_eks_cluster.prod.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "prod" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.prod-node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.large"
  name_prefix = "eks-prod"
  security_groups = [aws_security_group.prod-node.id]
  user_data_base64 = base64encode(local.prod-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "prod" {
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.prod.id
  max_size = 5
  min_size = 1
  name = "eks-prod"
  
  vpc_zone_identifier = module.vpc.public_subnets

  tag {
    key = "Name"
    value = "eks-prod"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}
