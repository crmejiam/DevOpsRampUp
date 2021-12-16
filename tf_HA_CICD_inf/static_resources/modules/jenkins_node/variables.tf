variable UbuntuAMI {}

variable InstanceType {}

variable AvailabilityZone {}

variable rampup_subnet_id {}

variable key_pair_name {}

variable trainee_tags {}

variable provisioner_file {}

variable ramp_up_training_id {}

variable port {}

variable ssh_port {}

variable github_webhook_ipv4 {
    description = "list of ips version 4 used by github to realize webhooks"
    type = list(string)
    default = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
  ]
}

variable github_webhook_ipv6 {
    description = "list of ips version 6 used by github to realize webhooks"
    type = list(string)
    default = [
    "2a0a:a440::/29",
    "2606:50c0::/32"
  ]
}