#--------------GKE---------------------------
resource "google_container_cluster" "gke_cluster" {
  name               = "my-cluster"
  location           = "us-central1-c"
  initial_node_count = "1"
  remove_default_node_pool = true
  ip_allocation_policy {
    
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.0.0.0/16"
    }
  }
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "192.168.1.0/28"
  }

  network = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.Restricted-Subnet.self_link
  addons_config {
    http_load_balancing {
      disabled = true
    }
  }
}

#-----------------------------Node Pool---------------------

resource "google_container_node_pool" "gke_node_pool" {
  name = "gke-node-pool"
  cluster = google_container_cluster.gke_cluster.name
  node_count = "1"
  node_config {
    service_account = google_service_account.gke_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    preemptible = true
    machine_type = "e2-medium"
  }
  location = google_container_cluster.gke_cluster.location
}




