output "vpc_id" {
  value = yandex_vpc_network.network.id
}
output "zone1" {
  value = yandex_vpc_subnet.subnet1.zone
}
output "zone2" {
  value = yandex_vpc_subnet.subnet2.zone
}

output "subnnn1" {
  value = yandex_vpc_subnet.subnet1.id
}
output "subnnn2" {
  value = yandex_vpc_subnet.subnet2.id
}

output "kube-network" {
  value = yandex_vpc_network.network.id
}
output "kube-v4_cidr_blocks" {
  value = yandex_vpc_subnet.subnet2.v4_cidr_blocks
}
