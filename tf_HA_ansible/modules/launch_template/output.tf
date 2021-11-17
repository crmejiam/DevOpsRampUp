output "launch_template_id" {
    description = "id of the launch template for the construction of instances in autoscaling group"
    value = "${aws_launch_template.app_launch_templates.id}"
}