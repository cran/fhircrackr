## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#"
)


hook_output = knitr::knit_hooks$get('output')
knitr::knit_hooks$set(output = function(x, options) {
	if (!is.null(n <- options$out.lines)){
	    if (any(nchar(x) > n)){
	    	index <- seq(1,nchar(x),n)
	    	x = substring(x, index, c(index[2:length(index)]-1, nchar(x)))
	    } 
	    x = paste(x, collapse = '\n# ')
	}
	hook_output(x, options)
})

# hook_warning = knitr::knit_hooks$get('warning')
# knitr::knit_hooks$set(warning = function(x, options) {
#     n <- 90
#     x = knitr:::split_lines(x)
#     # any lines wider than n should be wrapped
#     if (any(nchar(x) > n)) x = strwrap(x, width = n)
#     x = paste(x, collapse = '\n ')
#   hook_warning(x, options)
# })


## -----------------------------------------------------------------------------
library(fhircrackr)

## -----------------------------------------------------------------------------
fhir_url(url = "http://hapi.fhir.org/baseR4", resource = "Patient")

## ----warning=FALSE------------------------------------------------------------
fhir_resource_type(string = "Patient") #correct

fhir_resource_type(string = "medicationstatement") #fixed

fhir_resource_type(string = "medicationstatement", fix_capitalization = FALSE) #not fixed

fhir_resource_type(string = "Hospital") #an unknown resource type, a warning is issued
# Warnmeldung:
# In fhir_resource_type("Hospital") :
#   You gave "Hospital" as the resource type.
# This doesn't match any of the resource types defined under
# https://hl7.org/FHIR/resourcelist.html.
# If you are sure the resource type is correct anyway, you can ignore this warning.

## ---- out.lines=110-----------------------------------------------------------
request <- fhir_url(
	url        = "http://hapi.fhir.org/baseR4",
	resource   = "Patient",
	parameters = list(
		"birthdate" = "lt2000-01-01",
		"code"      = "http://loinc.org|1751-1"))

request

## ---- eval=F------------------------------------------------------------------
#  request <- fhir_url(url = "https://hapi.fhir.org/baseR4", resource = "Patient")
#  
#  patient_bundles <- fhir_search(request = request, max_bundles = 2, verbose = 0)

## ---- include=F---------------------------------------------------------------
patient_bundles <- fhir_unserialize(bundles = patient_bundles)

## ----results='hide'-----------------------------------------------------------
patient_bundles
# An object of class "fhir_bundle_list"
# [[1]]
# A fhir_bundle_xml object
# No. of entries : 20
# Self Link: http://hapi.fhir.org/baseR4/Patient
# Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# 
# {xml_node}
# <Bundle>
#  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#  [3] <type value="searchset"/>
#  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#  [6] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837602"/ ...
#  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/example-r ...
#  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837624"/ ...
#  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837626"/ ...
# [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837631"/ ...
# [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837716"/ ...
# [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837720"/ ...
# [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837714"/ ...
# [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837721"/ ...
# [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837722"/ ...
# [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837723"/ ...
# [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837724"/ ...
# [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/cfsb16116 ...
# [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837736"/ ...
# [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837737"/ ...
# ...
# 
# [[2]]
# A fhir_bundle_xml object
# No. of entries : 20
# Self Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# 
# {xml_node}
# <Bundle>
#  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#  [3] <type value="searchset"/>
#  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#  [6] <link>\n  <relation value="previous"/>\n  <url value="http://hapi.fhir.o ...
#  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837760"/ ...
#  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837766"/ ...
#  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837768"/ ...
# [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837781"/ ...
# [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837783"/ ...
# [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837784"/ ...
# [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837787"/ ...
# [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837788"/ ...
# [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837789"/ ...
# [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837790"/ ...
# [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837791"/ ...
# [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837792"/ ...
# [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837793"/ ...
# [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837794"/ ...
# ...

## -----------------------------------------------------------------------------
request <- fhir_url(
	url        = "https://hapi.fhir.org/baseR4/",
	resource   = "MedicationStatement",
	parameters = list(
		"code"     = "http://snomed.info/ct|429374003",
		"_include" = "MedicationStatement:subject"))

## ---- eval=F------------------------------------------------------------------
#  medication_bundles <- fhir_search(request = request, max_bundles = 3)

## ---- include=F---------------------------------------------------------------
medication_bundles <- fhir_unserialize(bundles = medication_bundles)

## ---- eval=F------------------------------------------------------------------
#  fhir_save(bundles = medication_bundles, directory = "MyProject/medicationBundles")

## -----------------------------------------------------------------------------
ids <- c("72622884-0a09-4ea9-9a91-685bce3b0fe3", 
		 "2ca48b68-a641-4be7-a39d-9ffe2691a29a", 
		 "8bcdd92d-5f96-4e07-9f6a-e22a3591ee30",
		 "2067558f-c9ed-489a-9c2f-7387bb3426a2", 
		 "5077b4b0-07c9-4d03-b9ec-1f9f218f8239")

## -----------------------------------------------------------------------------
id_strings <- paste(ids, collapse = ",")

## -----------------------------------------------------------------------------
#note the list()-expression
body <- fhir_body(content = list(
	"identifier"  = id_strings,
	"_revinclude" = "Observation:patient"))

## ---- eval = F----------------------------------------------------------------
#  url <- fhir_url(url = "https://hapi.fhir.org/baseR4/", resource = "Patient")
#  
#  bundles <- fhir_search(request = url, body = body)

## ---- eval=F------------------------------------------------------------------
#  medication_bundles <- fhir_search(
#  	request     = request,
#  	max_bundles = 3,
#  	log_errors  = "myErrorFile")

## -----------------------------------------------------------------------------
#serialize bundles
serialized_bundles <- fhir_serialize(bundles = patient_bundles)

#have a look at them
head(serialized_bundles[[1]])

## -----------------------------------------------------------------------------
#create temporary directory for saving
temp_dir <- tempdir()

#save
save(serialized_bundles, file = paste0(temp_dir, "/bundles.rda"))


## -----------------------------------------------------------------------------
#load bundles
load(paste0(temp_dir, "/bundles.rda"))

## ----results='hide'-----------------------------------------------------------
#unserialize
bundles <- fhir_unserialize(bundles = serialized_bundles)

#have a look
bundles
# An object of class "fhir_bundle_list"
# [[1]]
# A fhir_bundle_xml object
# No. of entries : 20
# Self Link: http://hapi.fhir.org/baseR4/Patient
# Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# 
# {xml_node}
# <Bundle>
#  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#  [3] <type value="searchset"/>
#  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#  [6] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837602"/ ...
#  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/example-r ...
#  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837624"/ ...
#  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837626"/ ...
# [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837631"/ ...
# [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837716"/ ...
# [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837720"/ ...
# [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837714"/ ...
# [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837721"/ ...
# [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837722"/ ...
# [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837723"/ ...
# [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837724"/ ...
# [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/cfsb16116 ...
# [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837736"/ ...
# [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837737"/ ...
# ...
# 
# [[2]]
# A fhir_bundle_xml object
# No. of entries : 20
# Self Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
# 
# {xml_node}
# <Bundle>
#  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#  [3] <type value="searchset"/>
#  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#  [6] <link>\n  <relation value="previous"/>\n  <url value="http://hapi.fhir.o ...
#  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837760"/ ...
#  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837766"/ ...
#  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837768"/ ...
# [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837781"/ ...
# [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837783"/ ...
# [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837784"/ ...
# [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837787"/ ...
# [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837788"/ ...
# [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837789"/ ...
# [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837790"/ ...
# [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837791"/ ...
# [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837792"/ ...
# [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837793"/ ...
# [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837794"/ ...
# ...

## -----------------------------------------------------------------------------
#save bundles as xml files
fhir_save(bundles = patient_bundles, directory = temp_dir)

## -----------------------------------------------------------------------------
bundles <- fhir_load(directory = temp_dir)

## ---- eval=F------------------------------------------------------------------
#  request <- fhir_url(url = "http://hapi.fhir.org/baseR4", resource = "Patient")
#  
#  fhir_search(
#  	request      = request,
#  	max_bundles  = 10,
#  	save_to_disc = "MyProject/downloadedBundles")
#  
#  bundles<- fhir_load(directory = "MyProject/downloadedBundles")

## ---- include=F---------------------------------------------------------------
assign(x = "last_next_link", value = fhir_url( "http://hapi.fhir.org/baseR4?_getpages=0be4d713-a4db-4c27-b384-b772deabcbc4&_getpagesoffset=200&_count=20&_pretty=true&_bundletype=searchset"), envir = fhircrackr:::fhircrackr_env)


## -----------------------------------------------------------------------------
strsplit(fhir_next_bundle_url(), "&")

## ---- eval=F------------------------------------------------------------------
#  #Starting fhir search request
#  url <- fhir_url(
#  	url        = "http://hapi.fhir.org/baseR4",
#  	resource   = "Observation",
#  	parameters = list("_count" = "500"))
#  
#  #count <- 0
#  
#  table_description <- fhir_table_description(resource = "Observation")
#  
#  while(!is.null(url)){
#  	
#  	#load 10 bundles
#  	bundles <- fhir_search(request = url, max_bundles = 10)
#  	
#  	#crack bundles
#  	dfs <- fhir_crack(bundles = bundles, design = table_description)
#  	
#  	#save cracked bundle to RData-file (can be exchanged by other data type)
#  	save(tables, file = paste0(tempdir(), "/table_", count, ".RData"))
#  	
#  	#retrieve starting point for next 10 bundles
#  	url <- fhir_next_bundle_url()
#  	
#  	# count <- count + 1
#  	# if(count >= 20) {break}
#  }
#  

## ---- eval=F------------------------------------------------------------------
#  cap <- fhir_capability_statement(url = "http://hapi.fhir.org/baseR4", verbose = 0)

