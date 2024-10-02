region = "eu-west-2"
project = "nia"
account_id = "067756640211"

mq_broker_name = "nia-broker"
root_domain = "nhsredteam.internal.nhs.uk"

enable_dlt = false
jenkins_worker_sg_id = "sg-09d9fdae9d92acce9"

jumpbox_allowed_ssh = [
 "82.28.74.154/32", # Answer digital VPN
 "20.68.179.45/32" # Made Tech VPN
]
