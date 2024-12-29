resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "subnets" {
    for_each = var.subnets

    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = each.value.cidr_block
    availability_zone       = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch

    tags = {
        Name = each.key
    }

    depends_on = [
        aws_vpc.vpc
    ]
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "main-igw"
    }

    depends_on = [
        aws_vpc.vpc
    ]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-route-table"
    }

    depends_on = [
        aws_internet_gateway.igw
    ]
}

resource "aws_route_table_association" "public_subnet_association" {
    for_each = var.subnets

    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.public.id

    depends_on = [
        aws_route_table.public,
        aws_subnet.subnets[each.key]
    ]
}

resource "aws_eip" "nat" {
    domain = "vpc"

    depends_on = [
        aws_internet_gateway.igw
    ]
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.subnets["public_1"].id

    tags = {
        Name = "main-nat-gateway"
    }

    depends_on = [
        aws_eip.nat
    ]
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }

    tags = {
        Name = "private-route-table"
    }

    depends_on = [
        aws_vpc.vpc,
        aws_nat_gateway.nat_gw
    ]
}

resource "aws_route_table_association" "private_subnet_association" {
    for_each = var.subnets

    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.private.id
    
    depends_on = [
        aws_route_table.private,
        aws_subnet.subnets[each.key]
    ]
}