#resource "aws_route53_record" "dbrw_record" {
#  zone_id = var.dns_zone_id
#  name    = "${var.name}-dbrw.${var.dns_zone}"
#  type    = "CNAME"
#  ttl     = 60
#  records = [aws_rds_cluster.this.endpoint]
#}
#
#resource "aws_route53_record" "dbro_record" {
#  zone_id = var.dns_zone_id
#  name    = "${var.name}-dbro.${var.dns_zone}"
#  type    = "CNAME"
#  ttl     = 60
#  records = [aws_rds_cluster.this.reader_endpoint]
#}