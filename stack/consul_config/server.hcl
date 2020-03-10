data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

# When the os has multiple NICs we need to tell
# Consul which to use for local advertise
advertise_addr = "10.5.0.20"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

telemetry {
  prometheus_retention_time = "30s"
}

config_entries {
  # We are using gateways and L7 config set the 
  # default protocol to HTTP
  bootstrap 
    {
      kind = "proxy-defaults"
      name = "global"

      config {
        protocol = "http"
      }

      mesh_gateway = {
        mode = "local"
      }
    }
}