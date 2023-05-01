variable "project_id" {
  description = "The project ID to host the cluster in"
}
variable "region" {
  description = "The region to host the cluster in"
  default     = "us-east1"
}
variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "bnewton-demo"
}
variable "gke_username" {
  default     = ""
  description = "gke username"
}
variable "gke_password" {
  default     = ""
  description = "gke password"
}
variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}