variable "region" {
    type        = string
    default     = "eu-north-1"
}

variable "vpc_cidr" {
    type        = string
    default     = "10.0.0.0/16"
}

variable "subnets" {
    type = map(object({
        cidr_block              = string
        availability_zone       = string
        map_public_ip_on_launch = bool
        })
    )
    default = {
        subnet1 = {
            cidr_block             = "10.0.1.0/24"
            availability_zone      = "eu-north-1a"
            map_public_ip_on_launch = true
        },
        subnet2 = {
            cidr_block             = "10.0.2.0/24"
            availability_zone      = "eu-north-1a"
            map_public_ip_on_launch = false
        }
    }
}


