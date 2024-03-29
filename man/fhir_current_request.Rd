% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_resources.R
\name{fhir_current_request}
\alias{fhir_current_request}
\title{Return FHIR search request used in last call to \code{\link[=fhir_search]{fhir_search()}} or \code{\link[=fhir_url]{fhir_url()}}}
\usage{
fhir_current_request()
}
\value{
An object of class \code{\link[=fhir_url]{fhir_url()}}
}
\description{
Return FHIR search request used in last call to \code{\link[=fhir_search]{fhir_search()}} or \code{\link[=fhir_url]{fhir_url()}}
}
\examples{
\donttest{
#the try({}, silent = TRUE) statement is only there to catch errors when the server is down
#you can skip it when the server is reachable

try({


request <- fhir_url(url = "https://server.fire.ly", resource = "Patient")
fhir_current_request()

fhir_search("https://server.fire.ly/Medication", max_bundles = 1)
fhir_current_request()


},silent = TRUE)

}


}
