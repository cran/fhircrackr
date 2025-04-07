## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#"
)

## -----------------------------------------------------------------------------
library(fhircrackr)

## -----------------------------------------------------------------------------
pat_bundles <- fhir_unserialize(bundles = patient_bundles)
med_bundles <- fhir_unserialize(bundles = medication_bundles)

## -----------------------------------------------------------------------------
pat_table_description <- fhir_table_description(
	resource = "Patient",
	cols     = list(
		id     = "id",
		gender = "gender",
		name   = "name/family",
		city   = "address/city"
	)
)

table <- fhir_crack(
	bundles = pat_bundles,
	design  = pat_table_description,
	verbose = 0
)

head(table)

## -----------------------------------------------------------------------------
fhir_table_description(resource = "Patient")

## -----------------------------------------------------------------------------
fhir_table_description(
	resource = "Patient",
	cols     = list(
		gender = "gender",
		name   = "name/family",
		city   = "address/city"
	)
)

## -----------------------------------------------------------------------------
#custom column names
fhir_columns(
	xpaths = c(
		gender = "gender",
		name   = "name/family",
		city   = "address/city"
	)
)
#automatic column names
fhir_columns(xpaths = c("gender", "name/family", "address/city"))

## -----------------------------------------------------------------------------
table_description <- fhir_table_description(
	resource = "Patient",
	cols     = list(
		gender = "gender",
		name   = "name/family",
		city   = "address/city"
	),
	sep           = "||",
	brackets      = c("[", "]"),
	rm_empty_cols = FALSE,
	format        = "compact",
	keep_attr     = FALSE
)

## -----------------------------------------------------------------------------
#define a table_description
table_description1 <- fhir_table_description(resource = "Patient")

#convert resources
#pass table_description1 to the design argument
table <- fhir_crack(bundles = pat_bundles, design = table_description1, verbose = 0)

#have look at part of the results
table[1:5,1:5]#38:42

#see the fill result with:
#View(table)

## -----------------------------------------------------------------------------
#define a table_description
table_description2 <- fhir_table_description(
	resource = "Patient",
	cols     = list(
		PID         = "id",
		use_name    = "name/use",
		given_name  = "name/given",
		family_name = "name/family",
		gender      = "gender",
		birthday    = "birthDate"
	)
)

#convert resources
table <- fhir_crack(bundles = pat_bundles, design = table_description2, verbose = 0)

#have look at the results
head(table)

## -----------------------------------------------------------------------------
fhir_canonical_design()

## -----------------------------------------------------------------------------
#all attributes defined explicitly
meds <- fhir_table_description(
	resource = "MedicationStatement",
	cols     = list(
		ms_id       = "id",
		status_text = "text/status",
		status      = "status",
		med_system  = "medicationCodeableConcept/coding/system",
		med_code    = "medicationCodeableConcept/coding/code"
	),
	sep           = "|",
	brackets      = NULL,
	rm_empty_cols = FALSE,
	format        = 'compact',
	keep_attr     = FALSE 
)

#automatic extraction/default values
pat <- fhir_table_description(resource = "Patient")

#combine both table_descriptions
design <- fhir_design(meds, pat)

## -----------------------------------------------------------------------------
design

## -----------------------------------------------------------------------------
design <- fhir_design(Medications = meds, Patients = pat)

design

## -----------------------------------------------------------------------------
design$Patients

## -----------------------------------------------------------------------------
list_of_tables <- fhir_crack(bundles = med_bundles, design = design, verbose = 0)

head(list_of_tables$Medications)

head(list_of_tables$Patients)

## -----------------------------------------------------------------------------
fhir_design(list_of_tables)

## -----------------------------------------------------------------------------
temp_dir <- tempdir()
fhir_save_design(design = design, file = paste0(temp_dir, "/design.xml"))

## -----------------------------------------------------------------------------
fhir_load_design(paste0(temp_dir, "/design.xml"))

## -----------------------------------------------------------------------------
bundle <- fhir_unserialize(example_bundles2)

## -----------------------------------------------------------------------------
desc1 <- fhir_table_description(resource = "Patient", sep = " | ")

df1 <- fhir_crack(bundles = bundle, design = desc1, verbose = 0)

df1

## -----------------------------------------------------------------------------
desc2 <- fhir_table_description(
	resource = "Patient",
	sep      = " | ",
	brackets = c("[", "]")
)

df2 <- fhir_crack(bundles = bundle, design = desc2, verbose = 0)

df2

## -----------------------------------------------------------------------------
df3 <- fhir_crack(bundles = bundle, design = desc2, format = "wide", verbose = 0)

df3

## -----------------------------------------------------------------------------
desc3 <- fhir_table_description(
	resource = "Patient",
	cols = c(id = "id",
			 name = "name/given",
			 address.city = "address[type[@value='physical'] and use[@value='home']]/city",
			 address.country = "address[type[@value='physical'] and use[@value='home']]/country"
			 )
)

df_selected <- fhir_crack(bundles = bundle, design = desc3, verbose = 0)
df_selected

## -----------------------------------------------------------------------------
bundle2 <- fhir_unserialize(bundles = example_bundles5)
desc4 <- fhir_table_description(resource = "Observation",
								cols = c(
									id = "id",
									code = "code/coding[system[@value='http://loinc.org']]/code",
								 	display = "code/coding[system[@value='http://loinc.org']]/display")
									 )
df_selected2 <- fhir_crack(bundles = bundle2,
					design = desc4,
					verbose = F)

df_selected2

## -----------------------------------------------------------------------------
 fhir_melt(
	indexed_data_frame = df2,
	columns            = "address.city",
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = TRUE
 )

## -----------------------------------------------------------------------------
cols <- c("address.city", "address.use", "address.type", "address.country")
 
fhir_melt(
	indexed_data_frame = df2,
	columns            = cols,
	brackets           = c("[", "]"), 
	sep	               = " | ",
	all_columns        = TRUE
)

## -----------------------------------------------------------------------------
cols <- fhir_common_columns(data_frame = df2, column_names_prefix = "address")
cols

## -----------------------------------------------------------------------------
fhir_melt(
	indexed_data_frame = df2,
	columns            = cols,
	brackets           = c("[", "]"), 
	sep                = " | ",
	all_columns        = FALSE
)

## -----------------------------------------------------------------------------
cols <- c(cols, "name.given")
fhir_melt(
	indexed_data_frame = df2,
	columns            = cols,
	brackets           = c("[", "]"), 
	sep                = " | ",
	all_columns        = TRUE
)

## -----------------------------------------------------------------------------
cols <- fhir_common_columns(data_frame = df2, column_names_prefix = "address")

molten_1 <- fhir_melt(
	indexed_data_frame = df2,
	columns            = cols,
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = TRUE
)

molten_1

molten_2 <- fhir_melt(
	indexed_data_frame = molten_1,
	columns            = "name.given",
	brackets           = c("[", "]"),
	sep                = " | ",
	all_columns        = TRUE
)

molten_2

## -----------------------------------------------------------------------------
fhir_rm_indices(indexed_data_frame = molten_2, brackets = c("[", "]"))

## -----------------------------------------------------------------------------
fhir_melt_all(indexed_data_frame = df2, brackets = c("[", "]"), sep = " | ")

## -----------------------------------------------------------------------------
fhir_cast(df2, brackets = c("[", "]"), sep = " | ", verbose = 0)

## ----include=F----------------------------------------------------------------
file.remove(paste0(temp_dir, "/design.xml"))

## -----------------------------------------------------------------------------
#unserialize example
bundles <- fhir_unserialize(bundles = example_bundles7)

#Define sep and brackets
sep <- "|"
brackets <- c("[", "]")

#crack fhir resources
table_desc <- fhir_table_description(
    resource = "Patient",
    brackets = brackets,
    sep = sep
)

df <- fhir_crack(bundles = bundles, design = table_desc, verbose = 0)
df

## -----------------------------------------------------------------------------
#name.given elements from the same name (i.e. the official vs. the nickname) 
#should be collapsed

df2 <- fhir_collapse(df, columns = "name.given", sep = sep, brackets = brackets)
df2

## -----------------------------------------------------------------------------
df2_molten <- fhir_melt(indexed_data_frame =  df2, 
						brackets = brackets, 
						sep = sep, 
						columns = fhir_common_columns(df2,"name"),
						all_columns = TRUE
						)
df2_molten

## -----------------------------------------------------------------------------
fhir_rm_indices(df2_molten, brackets = brackets)

