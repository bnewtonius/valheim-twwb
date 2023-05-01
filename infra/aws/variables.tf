variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
  default = "bnewton-demo"
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-east-2"
}

variable "cidr" {
  #This REALLY should be a /20 or greater.  Greater means reduce that 20 to a 19... IF SO, may have to tweak the other settings.
  description = "The cidr range to generate subnets and a dedicated vpc.  DO NOT make this less than 20 (remember CIDR notation is 21 is actually fewer IPs).  This has been tested with a size of /20, but should be tested with /19 and others."
  default = "172.20.0.0/20"
}
variable "cluster_name" {
  default = "bnewton-demo"
}

variable "private_tags" {
  description = "Tags used to identify private subnets"
  default = {
    Tier = "private"
  }
}

variable "kubeconfig_env_variables" {
  default = {
    AWS_PROFILE = "prod"
  }
}

variable "create_iam_roles" {
  default = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "Bnewton Demos"
    "Environment" = "Development"
    "Owner"       = "Brian Newton"
  }
}