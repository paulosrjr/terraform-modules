data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["${local.env}-private*"]
  }
  filter {
    name   = "tag:SubnetType"
    values = ["Private"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["${local.env}-public*"]
  }
  filter {
    name   = "tag:SubnetType"
    values = ["Public"]
  }
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}

data "aws_security_groups" "public" {
  filter {
    name   = "group-name"
    values = ["*-default-https", "*-default-http"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_lb" "public" {
  tags = { "Name" = local.env, "Tier" = "public" }
}

data "aws_acm_certificate" "public" {
  domain      = local.env
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
