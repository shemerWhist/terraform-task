# need to make the modules reusable.
# need to make "backend" and "providers" files, and move the configurations there.

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

module "s3" {
  source = "./modules/s3"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2_instances" {
  source             = "./modules/ec2"
  private_subnet1_id = module.vpc.private-subnet1.id
  private_subnet2_id = module.vpc.private-subnet2.id
  public_subnet1_id  = module.vpc.public-subnet1.id
  public_subnet2_id  = module.vpc.public-subnet2.id

  public-sg-id  = module.security_groups.public-group-id
  private-sg-id = module.security_groups.private-group-id
}

module "security_groups" {
  source         = "./modules/security-groups"
  vpc_id         = module.vpc.vpc-id
  vpc-cidr-block = module.vpc.vpc-cidr-block
}

module "alb" {
  source = "./modules/alb"

  vpc_id                 = module.vpc.vpc-id
  alb-sg-id              = module.security_groups.alb-security-group-id
  public_subnet1_id      = module.vpc.public-subnet1.id
  public_subnet2_id      = module.vpc.public-subnet2.id
  private-instance-1a-id = module.ec2_instances.private-instance-1a-id
  private-instance-1b-id = module.ec2_instances.private-instance-1b-id

  public-instance-1a-id = module.ec2_instances.public-instance-1a-id
  public-instance-1b-id = module.ec2_instances.public-instance-1b-id
}

module "asg" {
  source            = "./modules/asg"
  ami               = module.ec2_instances.ami-for-instance.id
  public_subnet1_id = module.vpc.public-subnet1.id
  public_subnet2_id = module.vpc.public-subnet2.id
  public-sg-id      = module.security_groups.public-group-id
  alb-arn           = module.alb.alb-arn
}

module "ecs" {
  source = "./modules/ecs"

  public-subnet1-id  = module.vpc.public-subnet1.id
  public-subnet2-id  = module.vpc.public-subnet2.id
  public-sg-id       = module.security_groups.public-group-id
  alb-arn            = module.alb.alb-arn
  asg-arn            = module.asg.asg-arn
}