## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=F------------------------------------------------------------------
#  library(fhircrackr)
#  patient_bundles <- fhir_search(request="http://fhir.hl7.de:8080/baseDstu3/Patient?",
#  							   max_bundles=2, verbose = 0)
#  

## ---- include=F---------------------------------------------------------------
library(fhircrackr)
patient_bundles <- fhir_unserialize(patient_bundles)

## -----------------------------------------------------------------------------
length(patient_bundles)
str(patient_bundles[[1]])

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design1 <- list(
  Patients = list(
    "//Patient"
  )
)

#Convert resources
list_of_tables <- fhir_crack(patient_bundles, design1, verbose = 0)

#have look at part of the results
list_of_tables$Patient[1:5,1:5]

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design2 <- list(
  Patients = list(
    "//Patient",
    "./*/@value"
  )
)

#Convert resources
list_of_tables <- fhir_crack(patient_bundles, design2, verbose = 0)

#have look at the results
head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design3 <- list(

	Patients = list(
		"//Patient",
		list(
			PID           = "id/@value",
			NAME.USE      = "name/use/@value",
			NAME.GIVEN    = "name/given/@value",
			NAME.FAMILY   = "name/family/@value",
			GENDER        = "gender/@value",
			BIRTHDAY      = "birthDate/@value"
		)
	)
)
#Convert resources
list_of_tables <- fhir_crack(patient_bundles, design3, verbose = 0)

#have look at the results
head(list_of_tables$Patients)

## ---- eval=F------------------------------------------------------------------
#  list(
#  
#  #Option 1: extract all attributes
#    <Name of first data frame> = list(
#      <XPath to resource type>
#    ),
#  
#  #Option 2: extract attributes from certain level
#    <Name of second data frame> = list(
#      <XPath to resource type>,
#      <XPath indicating attribute level>
#    ),
#  
#  #Option 3: extract specific attributes
#    <Name of third data frame> = list(
#      <XPath to resource type>,
#      list(
#        <column name 1> = <XPath to attribute>,
#        <column name 2> = <XPath to attribute>
#        ...
#      )
#    ),
#    ...
#  )

## -----------------------------------------------------------------------------
search_request  <- paste0(
  "https://hapi.fhir.org/baseR4/", #server endpoint
  "MedicationStatement?", #look for MedicationsStatements
  "code=http://snomed.info/ct|429374003", #only choose resources with this snomed code
  "&_include=MedicationStatement:subject") #include the corresponding Patient resources

## ---- eval=F------------------------------------------------------------------
#  medication_bundles <- fhir_search(search_request, max_bundles = 3)

## ---- include=F---------------------------------------------------------------
medication_bundles <- fhir_unserialize(medication_bundles)

## -----------------------------------------------------------------------------
design <- list(

	MedicationStatement = list(

		"//MedicationStatement",

		list(
			MS.ID              = "id/@value",
			STATUS.TEXT        = "text/status/@value",
			STATUS             = "status/@value",
			MEDICATION.SYSTEM  = "medicationCodeableConcept/coding/system/@value",
			MEDICATION.CODE    = "medicationCodeableConcept/coding/code/@value",
			MEDICATION.DISPLAY = "medicationCodeableConcept/coding/display/@value",
			DOSAGE             = "dosage/text/@value",
			PATIENT            = "subject/reference/@value",
			LAST.UPDATE        = "meta/lastUpdated/@value"
		)
	),

	Patients = list(

		"//Patient",
		"./*/@value"
	)
)


list_of_tables <- fhir_crack(medication_bundles, design, verbose = 0)

head(list_of_tables$MedicationStatement)

head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
bundle<-xml2::read_xml(
	"<Bundle>

		<Patient>
			<id value='id1'/>
			<address>
				<use value='home'/>
				<city value='Amsterdam'/>
				<type value='physical'/>
				<country value='Netherlands'/>
			</address>
			<birthDate value='1992-02-06'/>
		</Patient>

		<Patient>
			<id value='id2'/>
			<address>
				<use value='home'/>
				<city value='Rome'/>
				<type value='physical'/>
				<country value='Italy'/>
			</address>
			<address>
				<use value='work'/>
				<city value='Stockholm'/>
				<type value='postal'/>
				<country value='Sweden'/>
			</address>			
			<birthDate value='1980-05-23'/>
		</Patient>

		<Patient>
			<id value='id3.1'/>
			<id value='id3.2'/>
			<address>
				<use value='home'/>
				<city value='Berlin'/>
			</address>
			<address>
				<type value='postal'/>
				<country value='France'/>
			</address>
			<address>
				<use value='work'/>
				<city value='London'/>
				<type value='postal'/>
				<country value='England'/>
			</address>
			<birthDate value='1974-12-25'/>
		</Patient>		

	</Bundle>"
)

bundle_list<-list(bundle)

## -----------------------------------------------------------------------------
design1 <- list(
	Patients = list("//Patient")
)

df1 <- fhir_crack(bundle_list, design1, sep = " | ", verbose = 0)
df1$Patients

## -----------------------------------------------------------------------------
design2 <- list(
	Patients = list("//Patient")
)

df2 <- fhir_crack(bundle_list, design1, sep = " ", add_indices = T, 
				  brackets = c("[", "]"), verbose = 0)
df2$Patients

## -----------------------------------------------------------------------------
fhir_melt(df2$Patients, columns = "address.city.value", brackets = c("[","]"), 
		  sep=" ", all_columns = FALSE)

## -----------------------------------------------------------------------------
cols <- c("address.city.value", "address.use.value", "address.type.value", 
		  "address.country.value")

fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" ", all_columns = FALSE)

## -----------------------------------------------------------------------------
cols <- fhir_common_columns(df2$Patients, column_names_prefix = "address")
cols

## -----------------------------------------------------------------------------
fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" ", all_columns = TRUE)

## -----------------------------------------------------------------------------
cols <- c(cols, "id.value")
fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" ", all_columns = TRUE)


## -----------------------------------------------------------------------------
cols <- fhir_common_columns(df2$Patients, "address")

molten_1 <- fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
					  sep=" ", all_columns = TRUE)
molten_1

molten_2 <- fhir_melt(molten_1, columns = "id.value", brackets = c("[","]"), 
					  sep=" ", all_columns = TRUE)
molten_2

## -----------------------------------------------------------------------------
fhir_rm_indices(molten_2, brackets=c("[","]"), sep=" ")

## -----------------------------------------------------------------------------
#serialize bundles
serialized_bundles <- fhir_serialize(patient_bundles)

#have a look at them
head(serialized_bundles[[1]])

## ---- eval=F------------------------------------------------------------------
#  #create temporary directory for saving
#  temp_dir <- tempdir()
#  
#  #save
#  save(serialized_bundles, file=paste0(temp_dir, "\\bundles.rda"))
#  

## ---- eval=F------------------------------------------------------------------
#  #load bundles
#  load(paste0(temp_dir, "\\bundles.rda"))

## -----------------------------------------------------------------------------
#unserialize
bundles <- fhir_unserialize(serialized_bundles)

#have a look
head(bundles[[1]])

## ---- eval=F------------------------------------------------------------------
#  #save bundles as xml files
#  fhir_save(patient_bundles, directory=temp_dir)

## ---- eval=F------------------------------------------------------------------
#  bundles <- fhir_load(temp_dir)

## ---- eval=F------------------------------------------------------------------
#  cap <- fhir_capability_statement("http://hapi.fhir.org/baseR4/", verbose = 0)

## -----------------------------------------------------------------------------
design <- list(
	MedCodes=list("//medicationCodeableConcept/coding")
)

df <- fhir_crack(medication_bundles, design, verbose=0)

head(df$MedCodes)


