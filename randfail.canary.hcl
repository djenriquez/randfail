job "randfail" {
  datacenters = ["sandbox"]

  group "randfail" {
    count = 10
    task "server" {
      driver = "docker"

      config {
        image = "djenriquez/randfail"
        force_pull = true
        port_map = {
          http = 8080
        }
      }

      env {
        "FAIL_PERCENTAGE" = "33"
      }

      service {
        name = "randfail"
        port = "http"

        check {
          type     = "http"
          port     = "http"
          path     = "/hello"
          interval = "30s"
          timeout  = "3s"
          check_restart {
            limit = 1
            grace = "30s"
            ignore_warnings = false
          }
        }
      }

      resources {
        network {
          mbits = 100
          port "http" {}
        }
      }
    }

    restart {
      attempts = 0
      delay    = "10s"
    }

    update {
        max_parallel      = 5
        health_check      = "checks"
        min_healthy_time  = "10s"
        healthy_deadline  = "1m"
        progress_deadline = "10m"
        auto_revert       = false
        auto_promote      = false
        canary            = 10
    }

    reschedule {
      unlimited = true
      max_delay = "1m"
      delay = "10s"
    }

  }
}