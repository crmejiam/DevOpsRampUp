output "tier_load_balancer_arn" {
    description = "arn of the load balancer"
    value = "${aws_lb.application_load_balancer.arn}"
}

output "tier_load_balancer_address" {
    description = "address of the load balancer"
    value = "${aws_lb.application_load_balancer.dns_name}"
}