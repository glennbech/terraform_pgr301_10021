resource "google_cloud_run_service" "default" {
  name     = "terraformservicev2"
  location = "europe-north1"
  project = "pgr301-exam"

  template {
    spec {
      containers {
        image = "eu.gcr.io/pgr301-exam/pgr301_10021/devopsexam"
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}