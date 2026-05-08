resource "google_compute_network" "vpc" {
  name                    = "devops-vpc"
  auto_create_subnetworks = true
}

resource "google_container_cluster" "gke" {
  name     = "devops-cluster"
  location = "asia-south1"

  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  network = google_compute_network.vpc.name

  networking_mode = "VPC_NATIVE"

  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = 30
    machine_type = "e2-medium"
  }
}

resource "google_container_node_pool" "nodes" {
  name     = "devops-node-pool"
  cluster  = google_container_cluster.gke.name
  location = "asia-south1"

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"   # 1 vCPU, 4GB RAM — minimum viable for GKE

    disk_type    = "pd-standard"
    disk_size_gb = 30            # GKE recommended minimum

    image_type = "COS_CONTAINERD"
  }
}