output "tier_target_group_arn" {
    description = "arn of the load balancer target group"
    value = "${aws_lb_target_group.tier_target_group.arn}"
}