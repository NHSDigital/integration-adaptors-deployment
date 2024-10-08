
# Common setting for entire Env - "base" component
environment = "build1"
base_cidr_block = "10.11.0.0/16"
cluster_container_insights = "enabled"
docdb_instance_class = "db.r5.large"
mongo_ssl_enabled = true
enable_internet_access = "true"
postgres_instance_class = "db.t4g.micro"
create_postgres_db = true

# Settings for "nhais" component
nhais_service_minimal_count = 1
nhais_service_desired_count = 1
nhais_service_maximal_count = 1
nhais_service_target_request_count = 1200
nhais_service_container_port = 8080
nhais_service_launch_type = "FARGATE"
nhais_log_level = "DEBUG"
nhais_mesh_host = "https://msg.opentest.hscic.gov.uk/messageexchange/"
nhais_mesh_cert_validation = "true"
nhais_mongo_options = "replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&tls=true"

# Settings for "OneOneOne" component
# Name changed to "OneOneOne" from "111" because of problems with some Terraform names starting with number
OneOneOne_service_minimal_count = 2
OneOneOne_service_desired_count = 2
OneOneOne_service_maximal_count = 4
OneOneOne_service_target_request_count = 1200
OneOneOne_service_container_port = 8080
OneOneOne_service_launch_type = "FARGATE"
OneOneOne_log_level = "DEBUG"

# Settings for "gp2gp" component
gp2gp_service_desired_count = 1
gp2gp_service_minimal_count = 1
gp2gp_service_maximal_count = 1
gp2gp_service_container_port = 8080
gp2gp_service_launch_type = "FARGATE"
gp2gp_extract_cache_bucket_retention_period = 7
gp2gp_logs_datetime_format = "%Y-%m-%d %H:%M:%S%L"
gp2gp_mongo_options = "replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&tls=true"
gp2gp_ssl_trust_store_url = "s3://nhsd-aws-truststore/rds-truststore.jks"

# Settings for "gpc-consumer" component
gpc-consumer_service_minimal_count = 1
gpc-consumer_service_desired_count = 1
gpc-consumer_service_maximal_count = 1
gpc-consumer_service_target_request_count = 1200
gpc-consumer_service_container_port = 8080
gpc-consumer_service_launch_type = "FARGATE"
gpc-consumer_root_log_level = "WARN"
gpc-consumer_log_level = "INFO"
gpc-consumer_logs_datetime_format = "%Y-%m-%d %H:%M:%S%L"
gpc-consumer_override_gpc_provider_url = "https://GPConnect-Win1.itblab.nic.cfh.nhs.uk"
gpc-consumer_sds_url = "https://sandbox.api.service.nhs.uk/spine-directory/"
gpc-consumer_ssp_fqdn = ""

###### FOR GPC-CONSUMER TO BE DEPLOYED IN PTL ENVIRONMENT
#gpc-consumer_include_certs = true
#secret_name_spine_client_cert = "MHS_PTL_INT_Endpoint_Cert_v3"
#secret_name_spine_client_key = "MHS_PTL_INT_Endpoint_PrivateKey_v3"
#secret_name_spine_root_ca_cert = "MHS_PTL_INT_Endpoint_CA_SHA1_SHA2"
#secret_name_spine_sub_ca_cert = "MHS_PTL_INT_Endpoint_CA_SHA1_SHA2"
#secret_name_sds_apikey = ""

# Settings for "mhs" component
mhs_inbound_service_container_port = 443
mhs_inbound_service_healthcheck_port = 80
mhs_outbound_service_container_port = 80
mhs_route_service_container_port = 80
mhs_service_minimal_count = 1
mhs_service_desired_count = 1
mhs_service_maximal_count = 2
mhs_service_launch_type = "FARGATE"
mhs_log_level = "DEBUG"
mhs_inbound_queue_name = "build1_mhs_inbound"

mhs_outbound_alternative_image_tag = "nhsdev/nia-mhs-outbound:1.0.2"
mhs_inbound_alternative_image_tag =  "nhsdev/nia-mhs-inbound:1.0.2"
mhs_route_alternative_image_tag =  "nhsdev/nia-mhs-route:1.0.2"

mhs_outbound_forward_reliable_url = "https://192.168.128.11/reliablemessaging/forwardreliable"
mhs_route_sds_url = "ldap://192.168.128.11"

# Settings for "lab-results" component
lab-results_service_minimal_count = 1
lab-results_service_desired_count = 1
lab-results_service_maximal_count = 1
lab-results_service_target_request_count = 1200
lab-results_service_container_port = 8080
lab-results_service_launch_type = "FARGATE"
lab-results_log_level = "DEBUG"
lab-results_mesh_host = "https://msg.opentest.hscic.gov.uk/messageexchange/"
lab-results_mesh_cert_validation = "true"
lab-results_mongo_options = "replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&tls=true"
lab-results_logs_datetime_format = "%Y-%m-%d %H:%M:%S%L"
lab-results_ssl_trust_store_url = "s3://nhsd-aws-truststore/rds-truststore.jks"

# Settings for "pss" component
pss_service_minimal_count = 0
pss_service_desired_count = 0
pss_service_maximal_count = 0
pss_service_target_request_count = 1200
pss_service_launch_type = "FARGATE"
pss_logs_datetime_format = "%Y-%m-%d %H:%M:%S%L"
create_pss_testbox = false
pss_gp2gp_translator_testbox = false
pss_gpc_facade_testbox = false
pss_gpc_api_facade_container_port = 8081
pss_gp2gp_translator_container_port = 8085
pss_mock_mhs_port = 8080
pss_service_application_port = 8080
pss_log_level = "DEBUG"
