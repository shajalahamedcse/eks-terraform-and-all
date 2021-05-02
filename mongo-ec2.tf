# locals {
#   web_tags = {
#       Name = "mongodb"
#   }
# }

# resource "aws_instance" "web" {
#   ami = "ami-01581ffba3821cdf3" # ubuntu 20.04 for ap-southeast-1
#   instance_type = "t2.large"
#   subnet_id = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.mongo.id]
#   tags = local.web_tags
# }

# resource "aws_security_group" "mongo" {
#   name        = "mongo-sg"
#   description = "Security group for mongodb server"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "Allow all users to connect to mongodb"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     "Name"                                      = "mongo-sg"
#   }
# }
