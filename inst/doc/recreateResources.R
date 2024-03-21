## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#"
)

## -----------------------------------------------------------------------------
library(fhircrackr)

## -----------------------------------------------------------------------------
bundles <- fhir_unserialize(bundles = example_bundles2)

## -----------------------------------------------------------------------------
patients <- fhir_table_description(
  resource = "Patient",
  brackets = c("[", "]"),
  sep      = " | ",
  format   = "wide"
)

table <- fhir_crack(bundles = bundles, design = patients, verbose = 0)


## -----------------------------------------------------------------------------
table

## -----------------------------------------------------------------------------
#remove name and id
modified_table <- subset(table, select = -c(`[1.1]name.given`, `[2.1]name.given`, `[1]id`))

#anonymize city
modified_table[,1:3] <- sapply(modified_table[,1:3], function(x){sub(".*", "xxx", x)})


modified_table

## -----------------------------------------------------------------------------
cat(fhir_tree(modified_table, resource = "Patient", brackets = c("[", "]"), keep_ids = TRUE))

## -----------------------------------------------------------------------------
new_resource <- fhir_build_resource(row           = modified_table[1,], 
                                    resource_type = "Patient", 
                                    brackets      = c("[", "]"))

new_resource

## -----------------------------------------------------------------------------
transaction_bundle <- fhir_build_bundle(
  table         = modified_table,
  brackets      = c("[", "]"),
  resource_type = "Patient",
  bundle_type   = "transaction",
  verbose       = 0
)

## -----------------------------------------------------------------------------
#Overview
transaction_bundle

#print complete string
cat(toString(transaction_bundle))

## -----------------------------------------------------------------------------
request <- data.frame(
  request.method = c("POST",    "POST",    "POST"),
  request.url    = c("Patient", "Patient", "Patient")
)

request_table <- cbind(modified_table, request)

request_table

## -----------------------------------------------------------------------------
transaction_bundle <- fhir_build_bundle(
  table         = request_table,
  resource_type = "Patient",
  bundle_type   = "transaction", 
  brackets      = c("[", "]"),
  verbose       = 0
)

cat(toString(transaction_bundle))

## -----------------------------------------------------------------------------
fhir_unserialize(example_resource1)

## -----------------------------------------------------------------------------
fhir_unserialize(example_resource3)

## -----------------------------------------------------------------------------
bundle <- fhir_unserialize(example_bundles4)
med <- fhir_table_description(resource = "Medication", 
                              cols     = c("id", "ingredient", "ingredient/itemReference/reference"),
                              format   = "wide",
                              brackets = c("[", "]")
)
without_attribute <- fhir_crack(bundles = bundle, design = med, verbose = 0)
without_attribute

## -----------------------------------------------------------------------------
with_attribute <- fhir_crack(bundles = bundle, design = med, keep_attr = TRUE, verbose = 0)
with_attribute

## -----------------------------------------------------------------------------
fhir_build_resource(row = without_attribute[1,], resource_type = "Medication", brackets = c("[", "]"))

## -----------------------------------------------------------------------------
fhir_build_resource(row = with_attribute[1,], resource_type = "Medication", brackets = c("[", "]"))

## ----eval=FALSE---------------------------------------------------------------
#  fhir_post(url = "http://hapi.fhir.org/baseR4/Patient", body = new_resource)

## ----echo=FALSE---------------------------------------------------------------
message("Resource sucessfully created")

## -----------------------------------------------------------------------------
#create resource
new_resource_with_id <- fhir_build_resource(table[1,], resource_type = "Patient", brackets = c("[", "]"))

new_resource_with_id

## ----eval=FALSE---------------------------------------------------------------
#  fhir_put(url = "http://hapi.fhir.org/baseR4/Patient/id1", body = new_resource_with_id)

## ----echo=FALSE---------------------------------------------------------------
message("Ressource successfully updated.")

## ----eval=FALSE---------------------------------------------------------------
#  fhir_put(url = "http://hapi.fhir.org/baseR4/Patient/id1",
#           body = new_resource_with_id,
#           brackets = c("[", "]"))

## ----echo=FALSE---------------------------------------------------------------
message("Ressource successfully created.")

## -----------------------------------------------------------------------------
transaction_bundle

## ----eval=FALSE---------------------------------------------------------------
#  fhir_post("http://hapi.fhir.org/baseR4", body = transaction_bundle)

## ----echo=FALSE---------------------------------------------------------------
message("Bundle sucessfully POSTed")

## -----------------------------------------------------------------------------
#unserialize example bundles
bundles <- fhir_unserialize(example_bundles3)

#crack
Patient <- fhir_table_description(
  resource = "Patient",
  sep      = ":::",
  brackets = c("[","]"),
  format   = "wide"
)

Observation <- fhir_table_description(
  resource = "Observation",
  sep      = ":::",
  brackets = c("[","]"),
  format   = "wide"
)

tables <- fhir_crack(
  bundles = bundles,
  design  = fhir_design(Patient, Observation),
  verbose = 0
)


## -----------------------------------------------------------------------------
#add request info to Patients
tables$Patient$request.method <- "PUT"
tables$Patient$request.url <- paste0("Patient/", tables$Patient$`[1]id`)

#add request info to Observation
tables$Observation$request.method <- "PUT"
tables$Observation$request.url <- paste0("Observation/", tables$Observation$`[1]id`)

## -----------------------------------------------------------------------------
tables$Patient

## -----------------------------------------------------------------------------
tables$Observation

## -----------------------------------------------------------------------------
bundle <- fhir_build_bundle(table    = tables,
                            brackets = c("[","]"))

## -----------------------------------------------------------------------------
cat(toString(bundle))

## ----eval = F-----------------------------------------------------------------
#  fhir_post(url = "http://hapi.fhir.org/baseR4", body = bundle)

## ----echo=F-------------------------------------------------------------------
message("Bundle sucessfully POSTed")

