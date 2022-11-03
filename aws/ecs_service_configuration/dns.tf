resource "aws_route53_record" "record" {
  zone_id = local.dns_zone_id
  name    = "${local.application_url_entry}.${local.dns_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [local.load_balancer_url]
}
