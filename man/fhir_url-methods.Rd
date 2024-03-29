% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fhir_url.R
\docType{methods}
\name{fhir_url}
\alias{fhir_url}
\alias{fhir_url,character,missing,missing-method}
\alias{fhir_url,character,character,missing-method}
\alias{fhir_url,character,character,character-method}
\alias{fhir_url,character,character,list-method}
\title{Create FHIR URL}
\usage{
fhir_url(url, resource, parameters, url_enc = TRUE)

\S4method{fhir_url}{character,missing,missing}(url, url_enc = TRUE)

\S4method{fhir_url}{character,character,missing}(url, resource, url_enc = TRUE)

\S4method{fhir_url}{character,character,character}(url, resource, parameters, url_enc = TRUE)

\S4method{fhir_url}{character,character,list}(url, resource, parameters, url_enc = TRUE)
}
\arguments{
\item{url}{A character of length one specifying either the full search request,
e.g. \code{"http://hapi.fhir.org/baseR4/Patient?gender=male&_summary=count"}, or
the base URL to the FHIR server, e.g. \code{"http://hapi.fhir.org/baseR4"}.}

\item{resource}{A character of length one or \linkS4class{fhir_resource_type} object with the resource type to be searched, e.g. \code{"Patient"}.}

\item{parameters}{Optional. Either a length 1 character containing properly formatted FHIR search parameters, e.g.
\code{"gender=male&_summary=count"} or a named list or named character vector e.g. \code{list(gender="male", "_summary"="count")}
or \code{c(gender="male", "_summary"="count")}. Note that parameter names beginning with \verb{_} have to be put in quotation marks!}

\item{url_enc}{Should the url be URL-encoded? Defaults to \code{TRUE}.}
}
\value{
An object of class \linkS4class{fhir_url}
}
\description{
This function creates an object of class \linkS4class{fhir_url} which mostly represents a URL-encoded URL for
a FHIR search request. A valid Search URL contains a base URL and a resource type and may contain additional
search parameters. For more info on FHIR search see https://www.hl7.org/fhir/search.html.
}
\details{
You can use this function in two ways. If you provide just one string in the argument url with the full FHIR search request, this string
will be taken as a full FHIR search request. If you also provide the arguments \code{resource} and/or \code{parameters}, the string in \code{url} will be taken
as the base url of your FHIR server and the arguments will be concatenated appropriately to form the full request. See examples.

Note that only the latter approach does a validity check on the resource type!

You can disable URL-encoding by setting \code{url_enc=FALSE}.
}
\examples{

#provide full FHIR search request
fhir_url(url = "http://hapi.fhir.org/baseR4/Patient?gender=male&_summary=count")

#provide base url and resource type
fhir_url(
   url      = "http://hapi.fhir.org/baseR4",
   resource = "Patient"
 )

#parameters in one string
fhir_url(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = "gender=male&_summary=count"
 )

#parameters as a named character
fhir_url(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = c("gender" = "male", "_summary" = "count")
 )

#parameters as a named list
fhir_url(
   url        = "http://hapi.fhir.org/baseR4",
   resource   = "Patient",
   parameters = list("gender" = "male", "_summary" = "count")
 )
}
