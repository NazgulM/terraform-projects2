terraform {
  required_version = " >= 0.12"
}

provider "google" {
    region = "us-central1"
}

resource "google_project" "nazgul" {
  name = "nazgul"
  project_id = "nazgul-1234"
  billing_account = "011462-637D2F-B9F59E"
}

resource "null_resource" "cluster" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud config set project ${google_project.nazgul.project_id}"
  }
}

resource "null_resource" "unset-project" {
	provisioner "local-exec" {
	when = destroy
	command = "gcloud config unset project"
	}
}


resource "google_project_service" "project" {
  project = "nazgul-1234"
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "project1" {
  project = "nazgul-1234"
  service = "container.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "project2" {
  project = "nazgul-1234"
  service = "storage-api.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "project3" {
  project = "nazgul-1234"
  service = "dns.googleapis.com"

  disable_dependent_services = true
}