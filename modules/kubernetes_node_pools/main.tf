resource "google_container_node_pool" "node_pool" {
  count   = "${length(var.node_pools)}"
  name    = "${lookup(var.node_pools[count.index], "name")}"
  zone    = "${var.region}-${var.zones[0]}"
  cluster = "${var.cluster_name}"
  version = "${lookup(var.node_pools[count.index], "version")}"
  project = "${var.project}"

  autoscaling = {
    min_node_count = "${lookup(var.node_pools[count.index], "min_node_count")}"
    max_node_count = "${lookup(var.node_pools[count.index], "max_node_count")}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = "${lookup(var.node_pools[count.index], "preemptible")}"
    machine_type = "${lookup(var.node_pools[count.index], "machine_type")}"
    image_type   = "${lookup(var.node_pools[count.index], "image_type")}"

    labels {
      environment = "${var.environment}"
    }

    tags = "${split(" ", lookup(var.node_pools[count.index], "tags"))}"
  }
}
