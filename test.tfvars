region = "eu-north-1"
vpc_cidr = "10.0.0.0/16"

subnets = {
    public_1 = {
        cidr_block              = "10.0.1.0/24"
        availability_zone       = "eu-north-1a"
        map_public_ip_on_launch = true
    },
    private_2 = {
        cidr_block              = "10.0.2.0/24"
        availability_zone       = "eu-north-1a"
        map_public_ip_on_launch = false
    }
}