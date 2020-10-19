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
patient_bundles <- fhir_unserialize(fhircrackr::patient_bundles)

## -----------------------------------------------------------------------------
length(patient_bundles)
str(patient_bundles[[1]])

## -----------------------------------------------------------------------------
#define design
design1 <- list(
 
	 Patients = list(
   
	 	resource =  "//Patient"
	 )
)

#Convert resources
list_of_tables <- fhir_crack(bundles = patient_bundles, design = design1, verbose = 0)

#have look at part of the results
list_of_tables$Patients[1:5,1:5]

## -----------------------------------------------------------------------------
#define design
design2 <- list(
  
	Patients = list(
   
		resource =  "//Patient",
    
		cols = "./*"
	 )
)

#Convert resources
list_of_tables <- fhir_crack(bundles = patient_bundles, design = design2, verbose = 0)

#have look at the results
head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
#define design
design3 <- list(

	Patients = list(
		
		resource = "//Patient",
		
		cols = list(
			PID           = "id",
			use_name      = "name/use",
			given_name    = "name/given",
			family_name   = "name/family",
			gender        = "gender",
			birthday      = "birthDate"
		)
	)
)
#Convert resources
list_of_tables <- fhir_crack(bundles = patient_bundles, design = design3, verbose = 0)

#have look at the results
head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
design4 <- list(

	Patients = list(
		
		resource = "//Patient",
		
		cols = list(
			PID           = "id",
			use_name      = "name/use",
			given_name    = "name/given",
			family_name   = "name/family",
			gender        = "gender",
			birthday      = "birthDate"
		),
		
		style = list(
			sep = "|",
			brackets = c("[","]"),
			rm_empty_cols = FALSE
		)
	)
)

## -----------------------------------------------------------------------------
fhir_canonical_design()

## -----------------------------------------------------------------------------
search_request  <- paste0(
  "https://hapi.fhir.org/baseR4/", #server endpoint
  "MedicationStatement?", #look for MedicationsStatements
  "code=http://snomed.info/ct|429374003", #only choose resources with this snomed code
  "&_include=MedicationStatement:subject") #include the corresponding Patient resources

## ---- eval=F------------------------------------------------------------------
#  medication_bundles <- fhir_search(request = search_request, max_bundles = 3)

## ---- include=F---------------------------------------------------------------
medication_bundles <- fhir_unserialize(medication_bundles)

## -----------------------------------------------------------------------------
design <- list(

	MedicationStatement = list(

		resource = "//MedicationStatement",

		cols = list(
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
		
		style = list(
			sep = "|",
			brackets = NULL, 
			rm_empty_cols = FALSE
		)
	),

	Patients = list(

		resource = "//Patient",
		cols = "./*"
	)
)

## -----------------------------------------------------------------------------
list_of_tables <- fhir_crack(bundles = medication_bundles, design = design, verbose = 0)

head(list_of_tables$MedicationStatement)

head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
bundle <- xml2::read_xml(
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

bundle_list <- list(bundle)

## -----------------------------------------------------------------------------
design1 <- list(
	Patients = list(
		resource = "//Patient",
		cols = NULL, 
		style = list(
			sep = " | ",
			brackets  = NULL,
			rm_empty_cols = TRUE
		)
	)
)

df1 <- fhir_crack(bundles = bundle_list, design = design1, verbose = 0)
df1$Patients

## -----------------------------------------------------------------------------
design2 <- list(
	Patients = list(
		resource = "//Patient",
		cols = NULL, 
		style = list(
			sep = " | ",
			brackets  = c("[", "]"),
			rm_empty_cols = TRUE
		)
	)
)

df2 <- fhir_crack(bundles = bundle_list, design = design2, verbose = 0)
df2$Patients

## -----------------------------------------------------------------------------
design3 <- list(
	Patients = list(
		resource = "//Patient"
	)
)

df3 <- fhir_crack(bundles = bundle_list, 
				  design = design3, 
				  sep = " | ", 
				  brackets = c("[", "]"))


df3$Patients


fhir_canonical_design()

## -----------------------------------------------------------------------------
fhir_melt(df2$Patients, columns = "address.city", brackets = c("[","]"), 
		  sep=" | ", all_columns = FALSE)

## -----------------------------------------------------------------------------
cols <- c("address.city", "address.use", "address.type", 
		  "address.country")

fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" | ", all_columns = FALSE)

## -----------------------------------------------------------------------------
cols <- fhir_common_columns(df2$Patients, column_names_prefix = "address")
cols

## -----------------------------------------------------------------------------
fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" | ", all_columns = TRUE)

## -----------------------------------------------------------------------------
cols <- c(cols, "id")
fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
		  sep=" | ", all_columns = TRUE)


## -----------------------------------------------------------------------------
cols <- fhir_common_columns(df2$Patients, "address")

molten_1 <- fhir_melt(df2$Patients, columns = cols, brackets = c("[","]"), 
					  sep=" | ", all_columns = TRUE)
molten_1

molten_2 <- fhir_melt(molten_1, columns = "id", brackets = c("[","]"), 
					  sep=" | ", all_columns = TRUE)
molten_2

## -----------------------------------------------------------------------------
fhir_rm_indices(molten_2, brackets=c("[","]"))

## -----------------------------------------------------------------------------
#serialize bundles
serialized_bundles <- fhir_serialize(patient_bundles)

#have a look at them
head(serialized_bundles[[1]])

## -----------------------------------------------------------------------------
#create temporary directory for saving
temp_dir <- tempdir()

#save
save(serialized_bundles, file=paste0(temp_dir, "/bundles.rda"))


## -----------------------------------------------------------------------------
#load bundles
load(paste0(temp_dir, "/bundles.rda"))

## -----------------------------------------------------------------------------
#unserialize
bundles <- fhir_unserialize(serialized_bundles)

#have a look
head(bundles[[1]])

## -----------------------------------------------------------------------------
#save bundles as xml files
fhir_save(patient_bundles, directory=temp_dir)

## -----------------------------------------------------------------------------
bundles <- fhir_load(temp_dir)

## -----------------------------------------------------------------------------
fhir_save_design(design1, file = paste0(temp_dir,"/design.xml"))

## -----------------------------------------------------------------------------
fhir_load_design(paste0(temp_dir,"/design.xml"))

## ---- eval=F------------------------------------------------------------------
#  fhir_search("http://hapi.fhir.org/baseR4/Patient", max_bundles = 10,
#  			save_to_disc=TRUE, directory = paste0(temp_dir, "/downloadedBundles"))

## ---- include=F---------------------------------------------------------------
assign(x = "last_next_link", value = "http://hapi.fhir.org/baseR4?_getpages=0be4d713-a4db-4c27-b384-b772deabcbc4&_getpagesoffset=200&_count=20&_pretty=true&_bundletype=searchset", envir = fhircrackr:::fhircrackr_env)


## -----------------------------------------------------------------------------
fhir_next_bundle_url()

## -----------------------------------------------------------------------------
strsplit(fhir_next_bundle_url(), "&")

## ---- eval=F------------------------------------------------------------------
#  #Starting fhir search request
#  url <- "http://hapi.fhir.org/baseR4/Observation?_count=500"
#  
#  #count <- 0
#  
#  while(!is.null(url)){
#  	
#  	#load 10 bundles
#  	bundles <- fhir_search(url, max_bundles = 10)
#  	
#  	#crack bundles
#  	dfs <- fhir_crack(bundles, list(Obs=list(resource = "//Observation")))
#  	
#  	#save cracked bundle to RData-file (can be exchanged by other data type)
#  	save(tables, file = paste0(temp_dir,"/table_", count, ".RData"))
#  	
#  	#retrieve starting point for next 10 bundles
#  	url <- fhir_next_bundle_url()
#  	
#  	#count <- count + 1
#  	#if(count >= 20) {break}
#  }
#  

## ---- eval=F------------------------------------------------------------------
#  cap <- fhir_capability_statement("http://hapi.fhir.org/baseR4/", verbose = 0)

## -----------------------------------------------------------------------------
design <- list(
	MedCodes=list(resource = "//medicationCodeableConcept/coding")
)

df <- fhir_crack(medication_bundles, design, verbose=0)

head(df$MedCodes)


## ---- include=F---------------------------------------------------------------
file.remove(paste0(temp_dir,
				   c("/bundles.rda", "/design.xml", "/1.xml", "/2.xml"))
)

