% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fhir_url.R
\name{fhir_request}
\alias{fhir_request}
\title{fhir_request}
\usage{
fhir_request(url, resource = NULL, parameters = NULL, url_enc = TRUE)
}
\arguments{
\item{url}{The same as for \code{fhir_url()}.}

\item{resource}{The same as for \code{fhir_url()}. Defaults to NULL.}

\item{parameters}{The same as for \code{fhir_url()}. Defaults to NULL.}

\item{url_enc}{The same as for \code{fhir_url()}. Defaults to TRUE.}
}
\value{
The same as for \code{fhir_url()}.
}
\description{
A Wrapper for fhir_url
}
\examples{
#provide full FHIR search request
fhir_request(url = "http://hapi.fhir.org/baseR4/Patient?gender=male&_summary=count")

#provide base url and resource type
fhir_request(
   url      = "http://hapi.fhir.org/baseR4",
   resource = "Patient"
 )

#parameters in one string
fhir_request(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = "gender=male&_summary=count"
 )

#parameters as a named character
fhir_request(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = c("gender" = "male", "_summary" = "count")
 )

#parameters as a named list
fhir_request(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = list("gender" = "male", "_summary" = "count")
 )
}
