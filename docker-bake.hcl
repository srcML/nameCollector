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
  tags = [
    "${REGISTRY}/${IMAGE}:${TAG}",
  ]
}

target "local" {
  inherits  = ["namecollector"]
  platforms = ["linux/amd64"]
  output    = ["type=docker"]
  tags      = ["${IMAGE}:${TAG}"]
}
