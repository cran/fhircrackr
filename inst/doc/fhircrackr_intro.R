## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=F------------------------------------------------------------------
#  install.packages("fhircrackr")
#  library(fhircrackr)

## ---- include=F---------------------------------------------------------------
library(fhircrackr)

## ---- eval=F------------------------------------------------------------------
#  request <- fhir_url(url = "http://fhir.hl7.de:8080/baseDstu3", resource = "Patient")
#  patient_bundles <- fhir_search(request = request, max_bundles = 2, verbose = 0)

## ---- include=F---------------------------------------------------------------
patient_bundles <- fhir_unserialize(bundles = fhircrackr::patient_bundles)

## ----results='hide'-----------------------------------------------------------
length(patient_bundles)
#> [1] 2
patient_bundles
#> An object of class "fhir_bundle_list"
#> [[1]]
#> A fhir_bundle_xml object
#> No. of entries : 20
#> Self Link: http://hapi.fhir.org/baseR4/Patient
#> Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> 
#> {xml_node}
#> <Bundle>
#>  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#>  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#>  [3] <type value="searchset"/>
#>  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [6] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837602"/ ...
#>  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/example-r ...
#>  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837624"/ ...
#>  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837626"/ ...
#> [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837631"/ ...
#> [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837716"/ ...
#> [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837720"/ ...
#> [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837714"/ ...
#> [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837721"/ ...
#> [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837722"/ ...
#> [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837723"/ ...
#> [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837724"/ ...
#> [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/cfsb16116 ...
#> [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837736"/ ...
#> [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837737"/ ...
#> ...
#> 
#> [[2]]
#> A fhir_bundle_xml object
#> No. of entries : 20
#> Self Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> 
#> {xml_node}
#> <Bundle>
#>  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#>  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#>  [3] <type value="searchset"/>
#>  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [6] <link>\n  <relation value="previous"/>\n  <url value="http://hapi.fhir.o ...
#>  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837760"/ ...
#>  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837766"/ ...
#>  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837768"/ ...
#> [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837781"/ ...
#> [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837783"/ ...
#> [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837784"/ ...
#> [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837787"/ ...
#> [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837788"/ ...
#> [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837789"/ ...
#> [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837790"/ ...
#> [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837791"/ ...
#> [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837792"/ ...
#> [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837793"/ ...
#> [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837794"/ ...
#> ...

## -----------------------------------------------------------------------------
#define table_description
table_description <- fhir_table_description(
	resource = "Patient",
	cols     = c(
		PID         = "id",
		use_name    = "name/use",
		given_name  = "name/given",
		family_name = "name/family",
		gender      = "gender",
		birthday    = "birthDate"
	),
	sep           = " ~ ",
	brackets      = c("<<", ">>"),
	rm_empty_cols = FALSE,
	format        = 'compact',
	keep_attr     = FALSE
)

#have a look
table_description

## -----------------------------------------------------------------------------
#flatten resources
patients <- fhir_crack(bundles = patient_bundles, design = table_description, verbose = 0)

#have look at the results
head(patients)

## -----------------------------------------------------------------------------
request  <- fhir_url(
	url        = "https://hapi.fhir.org/baseR4", 
	resource   = "MedicationStatement", 
	parameters = c(
		 "code"    = "http://snomed.info/ct|429374003",
		"_include" = "MedicationStatement:subject"))

## ---- eval=F------------------------------------------------------------------
#  medication_bundles <- fhir_search(request = request, max_bundles = 3)

## ---- include=F---------------------------------------------------------------
medication_bundles <- fhir_unserialize(bundles = medication_bundles)

## -----------------------------------------------------------------------------
MedicationStatements <- fhir_table_description(
	resource = "MedicationStatement",
	cols     = c(
		MS.ID              = "id",
		STATUS.TEXT        = "text/status",
		STATUS             = "status",
		MEDICATION.SYSTEM  = "medicationCodeableConcept/coding/system",
		MEDICATION.CODE    = "medicationCodeableConcept/coding/code",
		MEDICATION.DISPLAY = "medicationCodeableConcept/coding/display",
		DOSAGE             = "dosage/text",
		PATIENT            = "subject/reference",
		LAST.UPDATE        = "meta/lastUpdated"
	),
	sep           = "|",
	brackets      = NULL,
	rm_empty_cols = FALSE,
	format        = "compact",
	keep_attr     = FALSE
)

Patients <- fhir_table_description(resource = "Patient")

design <- fhir_design(MedicationStatements, Patients)


## -----------------------------------------------------------------------------
design

## -----------------------------------------------------------------------------
list_of_tables <- fhir_crack(bundles = medication_bundles, design = design, verbose = 0)

list_of_tables$MedicationStatements[1:5,]

list_of_tables$Patients[18:20,]

## -----------------------------------------------------------------------------
bundles <- fhir_unserialize(bundles = example_bundles1)

## -----------------------------------------------------------------------------
table_description <- fhir_table_description(
	resource = "Patient",
	brackets      = c("[", "]"),
	sep           = " | ",
	rm_empty_cols = FALSE,
	format        = 'compact',
	keep_attr     = FALSE
)

df <- fhir_crack(bundles = bundles, design = table_description, verbose = 0)

df

## -----------------------------------------------------------------------------
fhir_melt(
	indexed_data_frame = df,
	columns            = "address.city",
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = FALSE
)

## -----------------------------------------------------------------------------
cols <- c("address.city", "address.use", "address.type", "address.country")

fhir_melt(
	indexed_data_frame = df,
	columns            = cols,
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = FALSE
)

## -----------------------------------------------------------------------------
molten <- fhir_melt(
	indexed_data_frame = df,
	columns            = cols,
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = TRUE
)

molten

## -----------------------------------------------------------------------------
fhir_rm_indices(indexed_data_frame = molten, brackets = c("[", "]"))

## -----------------------------------------------------------------------------
#serialize bundles
serialized_bundles <- fhir_serialize(bundles = patient_bundles)

#have a look at them
head(serialized_bundles[[1]])

## -----------------------------------------------------------------------------
#create temporary directory for saving
temp_dir <- tempdir()

#save
saveRDS(serialized_bundles, file = paste0(temp_dir, "/bundles.rda"))


## -----------------------------------------------------------------------------
#load bundles
serialized_bundles_reloaded <- readRDS(paste0(temp_dir, "/bundles.rda"))

## ----results='hide'-----------------------------------------------------------
#unserialize
bundles <- fhir_unserialize(bundles = serialized_bundles_reloaded)

#have a look
bundles
#> An object of class "fhir_bundle_list"
#> [[1]]
#> A fhir_bundle_xml object
#> No. of entries : 20
#> Self Link: http://hapi.fhir.org/baseR4/Patient
#> Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> 
#> {xml_node}
#> <Bundle>
#>  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#>  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#>  [3] <type value="searchset"/>
#>  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [6] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837602"/ ...
#>  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/example-r ...
#>  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837624"/ ...
#>  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837626"/ ...
#> [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837631"/ ...
#> [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837716"/ ...
#> [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837720"/ ...
#> [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837714"/ ...
#> [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837721"/ ...
#> [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837722"/ ...
#> [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837723"/ ...
#> [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837724"/ ...
#> [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/cfsb16116 ...
#> [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837736"/ ...
#> [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837737"/ ...
#> ...
#> 
#> [[2]]
#> A fhir_bundle_xml object
#> No. of entries : 20
#> Self Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> Next Link: http://hapi.fhir.org/baseR4?_getpages=ce958386-53d0-4042-888c-cad53bf5d5a1 ...
#> 
#> {xml_node}
#> <Bundle>
#>  [1] <id value="ce958386-53d0-4042-888c-cad53bf5d5a1"/>
#>  [2] <meta>\n  <lastUpdated value="2021-05-10T12:12:43.317+00:00"/>\n</meta>
#>  [3] <type value="searchset"/>
#>  [4] <link>\n  <relation value="self"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [5] <link>\n  <relation value="next"/>\n  <url value="http://hapi.fhir.org/b ...
#>  [6] <link>\n  <relation value="previous"/>\n  <url value="http://hapi.fhir.o ...
#>  [7] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837760"/ ...
#>  [8] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837766"/ ...
#>  [9] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837768"/ ...
#> [10] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837781"/ ...
#> [11] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837783"/ ...
#> [12] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837784"/ ...
#> [13] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837787"/ ...
#> [14] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837788"/ ...
#> [15] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837789"/ ...
#> [16] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837790"/ ...
#> [17] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837791"/ ...
#> [18] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837792"/ ...
#> [19] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837793"/ ...
#> [20] <entry>\n  <fullUrl value="http://hapi.fhir.org/baseR4/Patient/1837794"/ ...
#> ...

## -----------------------------------------------------------------------------
#save bundles as xml files
fhir_save(bundles = patient_bundles, directory = temp_dir)

## -----------------------------------------------------------------------------
bundles <- fhir_load(directory = temp_dir)

## ---- include=F---------------------------------------------------------------
file.remove(
	paste0(
		temp_dir,
		c(
			"/bundles.rda",
			"/design.xml",
			"/1.xml",
			"/2.xml"
		)
	)
)

