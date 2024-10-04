terraform {
  backend "gcs" {
    # NOTE: the gcs_bucket_name output from code-challenge-tfstate
    bucket = "code-challenge-62079-tfstate"
  }
}
