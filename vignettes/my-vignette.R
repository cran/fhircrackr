## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- results=F, message=F----------------------------------------------------
library(fhircrackr)
patient_bundles <- fhir_search(request="http://hapi.fhir.org/baseR4/Patient?", max_bundles=2)


## -----------------------------------------------------------------------------
str(patient_bundles)

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design1 <- list(
  Patients = list(
    ".//Patient"
  )
)

#Convert resources
list_of_tables <- fhir_crack(patient_bundles, design1)

#have look at part of the results
list_of_tables$Patients[1:5,5:10]

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design2 <- list(
  Patients = list(
    ".//Patient",
    "./*/@value"
  )
)

#Convert resources
list_of_tables <- fhir_crack(patient_bundles, design2)

#have look at the results
head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
#define which elements of the resources are of interest
design3 <- list(
	
	Patients = list(
		".//Patient",
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
list_of_tables <- fhir_crack(patient_bundles, design3)

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
  "code=http://snomed.info/ct|429374003", #only choose resources with this loinc code
  "&_include=MedicationStatement:subject") #include the corresponding Patient resources

## ---- results=F, message=F----------------------------------------------------
medication_bundles <- fhir_search(search_request, max_bundles = 3)

## -----------------------------------------------------------------------------
design <- list(

	MedicationStatement = list(

		".//MedicationStatement",

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

		".//Patient",
		"./*/@value"
	)
)


list_of_tables <- fhir_crack(medication_bundles, design)

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
				<id value='id3'/> 
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
	Patients = list(".//Patient")
)

df1 <- fhir_crack(bundle_list, design1, sep = " | ",)
df1$Patients

## -----------------------------------------------------------------------------
design2 <- list(
	Patients = list(".//Patient")
)

df2 <- fhir_crack(bundle_list, design1, sep = " ", add_indices = T, brackets = c("<", ">") )
df2$Patients

## -----------------------------------------------------------------------------
#serialize bundles
serialized_bundles <- fhir_serialize(patient_bundles)

#have a look at them
head(serialized_bundles[[1]])

#save
save(serialized_bundles, file="bundles.rda")

## -----------------------------------------------------------------------------
#load bundles
load("bundles.rda")

#unserialize
bundles <- fhir_unserialize(serialized_bundles)

#have a look
head(bundles[[1]])

## -----------------------------------------------------------------------------
#save bundles as xml files
fhir_save(patient_bundles, directory="MyDirectory")

## -----------------------------------------------------------------------------
bundles <- fhir_load("MyDirectory")

## ---- results=F---------------------------------------------------------------
cap <- fhir_capability_statement("http://hapi.fhir.org/baseR4/")

## -----------------------------------------------------------------------------
cap$META$software.version

## -----------------------------------------------------------------------------
design <- list(
	MedCodes=list(".//medicationCodeableConcept/coding")
)

df <- fhir_crack(medication_bundles, design)

head(df$MedCodes)


