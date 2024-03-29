% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gcloud_sync.R
\name{cloud_sync_artifacts}
\alias{cloud_sync_artifacts}
\title{Sync all artifacts to cloud}
\usage{
cloud_sync_artifacts(secret, artifacts, repos)
}
\arguments{
\item{secret}{character() path where secret, i.e a service key for
access to an object store on google or azure.}

\item{artifacts}{list()}

\item{repos}{list()}
}
\description{
Sync all artifacts to cloud
}
\details{
Sync packages, logs to cloud storage based on which cloud
    is used.
}
