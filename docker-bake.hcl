variable "REGISTRY" {
  default = "docker.io/srcml"
}

variable "IMAGE" {
  default = "namecollector"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["namecollector"]
}

target "namecollector" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64"]
  args = {
    CACHEBUST = "${timestamp()}"
  }
  tags = [
    "${REGISTRY}/${IMAGE}:1.0.0",
    "${REGISTRY}/${IMAGE}:1.0",
    "${REGISTRY}/${IMAGE}:1",
    "${REGISTRY}/${IMAGE}:latest",
  ]
}

target "local" {
  inherits  = ["namecollector"]
  platforms = ["linux/amd64"]
  output    = ["type=docker"]
  tags      = ["${IMAGE}:${TAG}"]
}
