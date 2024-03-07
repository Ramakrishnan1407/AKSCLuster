variable "resource_group" {
  type        = string
  description = "Platform owner AAD security group"
  default = {
    projects:
  - code: conn
    application_ingresses:
      - application_name: shapconnect
        public: false
        path: /
        path_service_name: shapconnect
        path_service_port_number: 80
  }
}


