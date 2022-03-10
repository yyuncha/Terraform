locals {
    subnet_mapping = {
        for count in range(length(var.subnet_mapping)):
            var.ap_subnet_ids[count] => var.subnet_mapping[count]
    }
}