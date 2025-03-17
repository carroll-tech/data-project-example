data "google_client_openid_userinfo" "me" {}

data "google_iam_policy" "default_node" {
  binding {
    role = "roles/container.defaultNodeServiceAccount"

    members = [
      "serviceAccount:${google_service_account.nodes.email}",
    ]
  }
}