% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fhir_body.R
\docType{class}
\name{fhir_body-class}
\alias{fhir_body-class}
\title{An s4 class to represent a body for a POST to a FHIR server}
\description{
Objects of this class should always be created with a call to the function \code{\link[=fhir_body]{fhir_body()}}
}
\section{Slots}{

\describe{
\item{\code{content}}{A vector of length one representing the body for the post.}

\item{\code{type}}{A vector of length one defining the type of the body e.g. \code{"application/x-www-form-urlencoded"} or \code{"xml"}.}
}}

