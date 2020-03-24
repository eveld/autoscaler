job "webapp" {
  datacenters = ["dc1"]

  group "demo" {
    count = 1

    scaling {
      enabled = true

      policy {
        source = "prometheus"
        query  = "scalar(haproxy_backend_http_response_time_average_seconds{backend=\"http_back\"})"

        strategy = {
          name = "target-value"
          min  = 1
          max  = 10

          config = {
            target = 0.156
          }
        }
      }
    }

    task "server" {
      driver = "docker"

      config {
        image          = "hashicorp/demo-webapp-lb-guide"
        cpu_hard_limit = true

        ulimit {
          nofile = "512:512"
        }
      }

      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }

      resources {
        cpu = 50
        memory = 128

        network {
          mbits = 10
          port  "http"{}
        }
      }

      service {
        name = "webapp"
        port = "http"

        meta {
          version = "v3"
        }

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}