
variable "project" {
  description = "The GCP project to deploy resources in"
  type        = string
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy resources in"
  type        = string
  default     = "us-central1-a"
}

variable "instance_type" {
  description = "The type of instance to deploy"
  type        = string
  default     = "n1-standard-1"
}

variable "ssh_public_key" {
  description = "The SSH public key"
  type        = string
}

variable "disk_size" {
  description = "The size of the persistent disk"
  type        = string
  default     = "10"
}
