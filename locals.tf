locals {
    app_name = "si"
    branch_name = "main"

    cidr = "10.0.0.0/16"
    
    private_cidr_start = "10.0.1.0/28"
    private_cidr_stop =  "10.0.2.0/28"
    public_cidr_start = "10.0.4.0/28"
    public_cidr_stop =  "10.0.5.0/28"
}