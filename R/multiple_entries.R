## This file contains all functions dealing with multiple entries/indices##
## Exported functions are on top, internal functions below ##

#' Cast table with multiple entries
#' This function divides multiple entries in a compact indexed table as produced by [fhir_crack()] into separate columns.
#'
#' This function turns a table from compact format into wide format. Every column containing multiple entries will be turned into multiple columns.
#' The number of columns created from a single column in the original table is determined by the maximum number of
#' multiple entries occurring in this column. Rows with less than the maximally occurring number of entries will
#' be filled with NA values.
#'
#' For [fhir_cast()] to work properly, column names of the input data must reflect the Xpath to the corresponding resource element
#' with `.` as a separator, e.g. `code.coding.system`. These names are produced automatically by [fhir_crack()]
#' when the names are not explicitly set in the `cols` element of the [fhir_table_description()]/[fhir_design()].
#'
#' In the names of the newly created columns the indices will be added in front of the column names, similar to the result of [fhir_crack()] with
#' `format="wide"`. See examples and the corresponding package vignette for a more detailed description.
#'
#' @param indexed_df A compact data.frame/data.table with indexed multiple entries. Column names should reflect the XPath expression of the respective element.
#' @param brackets A character vector of length two, defining the brackets used for the indices.
#' @param sep A character vector of length one defining the separator that was used when pasting together multiple entries in [fhir_crack()].
#' @param verbose An integer vector of length one. If 0, nothing is printed, if 1, only general progress is printed, if > 1,
#' progress for each variable is printed. Defaults to 1.
#' @export
#' @examples
#'
#' #unserialize example
#' bundles <- fhir_unserialize(bundles = example_bundles1)
#'
#' #crack fhir resources
#' table_desc <- fhir_table_description(
#'     resource = "Patient",
#'     brackets = c('[', ']'),
#'     sep      = " ",
#'     keep_attr=TRUE
#' )
#' df <- fhir_crack(bundles = bundles, design = table_desc)
#'
#' #original df
#' df
#'
#' #cast
#' fhir_cast(df, brackets=c('[', ']'), sep = ' ', verbose = 0)
#'
#' @seealso [fhir_crack()], [fhir_melt()], [fhir_build_bundle()]
fhir_cast <- function(
	indexed_df,
	brackets,
	sep,
	verbose = 1) {

	if(is.null(indexed_df)) {stop("indexed_df is NULL.")}
	if(nrow(indexed_df) < 1) {stop("indexed_df doesn't contain any data.")}

	is_DT <- data.table::is.data.table(x = indexed_df)
	if(!is_DT) {data.table::setDT(x = indexed_df)}

	col_names <- names(indexed_df)
	sep_ <- esc(sep)
	brackets <- fix_brackets(brackets)
	bra_ <- esc(brackets[1])
	ket_ <- esc(brackets[2])
	regexpr_ids <- stringr::str_c(bra_, "([0-9]+(\\.[0-9]+)*)", ket_, "(.*$)")

	if(!any(grepl(regexpr_ids, indexed_df[1,]))){
		stop("Cannot find ids with the specified brackets in the table.")
	}

	if(0 < verbose) {message("Expanding table...\n")}

	map <- sapply(
		col_names,
		function(name) {
			#name <- names(indexed_df)[[6]]
			if(1 < verbose) {message(name)}

			warning_given <- FALSE
			entries <- strsplit(indexed_df[[name]], sep_)
			ids <- lapply(entries, function(entry){gsub(regexpr_ids, "\\1", entry)})
			name_vec <- strsplit(name, "\\.")[[1]]

			name_expanded <- unlist(
				lapply(
					ids[sapply(ids, function(i){all(!is.na(i))})],
					function(id){
						#id <- ids[sapply(ids, function(i) all(!is.na(i)))][[1]]
						id_ <- strsplit(id, "\\.")
						names(id_) <- id

						if(length(id_[[1]])!=length(name_vec) && !warning_given){
							warning(
								"Column name '", stringr::str_c(name_vec, collapse = "."),
								"' doesn't fit the id pattern found in this column.",
								"The column name should be build the way ",
								"fhir_crack() automatically builds it. See ?fhir_cast."
							)
							warning_given <<- TRUE
						}

						if(1 < length(name_vec)) {
							sapply(
								id_,
								function(i_) {
									i_ <- as.numeric(i_)
									stringr::str_c(stringr::str_c(brackets[1],paste(i_, collapse="."), brackets[2]), paste(name_vec, collapse = "."))

								},
								simplify = FALSE
							)
						} else {
							i <- as.numeric(id)
							a <- stringr::str_c(brackets[1], i, brackets[2], name_vec)
							names(a) <- id
							a
						}
					}
				),
				use.names = T
			)
			sort(name_expanded[unique(names(name_expanded))])
		},
		simplify = FALSE
	)

	df_new_names <- unlist(map, use.names = FALSE)
	d <- data.table(matrix(data = rep_len(character(), nrow(indexed_df) * length(df_new_names)), nrow = nrow(indexed_df), ncol = length(df_new_names)))
	setnames(d, df_new_names)

	if(0 < verbose) {message("\nFilling table...\n")}

	for(name in names(map)) {
		#name <- names(map)[[1]]
		if(1 < verbose) {message(name, ":")}

		for(id in names(map[[name]])) {
			#id <- names(map[[name]])[[1]]
			sname <- map[[name]][[id]]
			if(1 < verbose) {message("   ", sname)}
			id_str <- stringr::str_c(bra_, id, ket_)
			row_with_id <- grep(id_str, indexed_df[[name]], perl = T)
			entries <- strsplit(indexed_df[[name]][row_with_id], sep_)
			values <- gsub(
				id_str,
				"",
				sapply(
					entries,
					function(entry) {
						entry[grep(id_str, entry, perl = T)]
					},
					simplify = FALSE
				)
			)
			d[row_with_id, (sname) := values]
		}
	}
	if(!is_DT) {setDF(d)}
	d[]#to avoid problems with printing
	d
}

#' Find common columns
#'
#' This is a convenience function to find all column names in a data frame starting with the same string that can
#' then be used for [fhir_melt()].
#'
#' It is intended for use on data frames with column names that have been automatically produced by [fhir_design()]/[fhir_crack()]
#' and follow the form `level1.level2.level3` such as `name.given` or `code.coding.system`.
#' Note that this function will only work on column names following exactly this scheme.
#'
#' The resulting character vector can be used for melting all columns belonging to the same attribute in an indexed data frame,
#' see `?fhir_melt`.
#'
#' @param data_frame A data.frame/data.table with automatically named columns as produced by [fhir_crack()].
#' @param column_names_prefix A string containing the common prefix of the desired columns.
#' @return A character vector with the names of all columns matching `column_names_prefix`.
#' @examples
#' #unserialize example bundles
#' bundles <- fhir_unserialize(bundles = medication_bundles)
#'
#' #crack Patient Resources
#' pats <- fhir_table_description(resource = "Patient")
#'
#' df <- fhir_crack(bundles = bundles, design = pats)
#'
#' #look at automatically generated names
#' names(df)
#'
#' #extract all column names beginning with the string "name"
#' fhir_common_columns(data_frame = df, column_names_prefix = "name")
#' @export
#' @seealso [fhir_melt()], [fhir_rm_indices()]
#'
fhir_common_columns <- function(data_frame, column_names_prefix) {
	if(!is.data.frame(data_frame)) {
		stop(
			"You need to supply a data.frame or data.table to the argument indexed_data_frame.",
			"The object you supplied is of type ", class(data_frame), "."
		)
	}
	pattern_column_names  <- stringr::str_c("^", column_names_prefix, "($|\\.+)")
	column_names <- names(data_frame)
	hits <- grepl(pattern_column_names, column_names)
	if(!any(hits)) {stop("The column prefix you gave doesn't appear in any of the column names.")}
	column_names[hits]
}


#' Melt multiple entries
#'
#' This function divides multiple entries in an indexed data frame as produced by [fhir_crack()]
#' into separate rows.
#'
#' Every row containing values that consist of multiple entries on the variables specified by the argument `columns`
#' will be turned into multiple rows, one for each entry. Values on other variables will be repeated in all the new rows.
#'
#' The new data.frame will contain only the molten variables (if `all_cloumns = FALSE`) or all variables
#' (if `all_columns = TRUE`) as well as an additional variable `resource_identifier` that maps which rows came
#' from the same origin. The name of this column can be changed in the argument `id_name`.
#'
#' For a more detailed description on how to use this function please see the corresponding package vignette.
#'
#' @param indexed_data_frame A data.frame/data.table with indexed multiple entries.
#' @param columns A character vector specifying the names of all columns that should be molten simultaneously.
#' It is advisable to only melt columns simultaneously that belong to the same (repeating) attribute!
#' @param brackets A character vector of length two, defining the brackets used for the indices.
#' @param sep A character vector of length one defining the separator that was used when pasting together multiple entries in [fhir_crack()].
#' @param id_name A character vector of length one, the name of the column that will hold the identification of the origin of the new rows.
#' @param all_columns Return all columns? Defaults to `FALSE`, meaning only those specified in `columns` are returned.
#'
#' @return A data.frame/data.table where each entry from the variables in `columns` appears in a separate row.
#'
#' @examples
#' #unserialize example
#' bundles <- fhir_unserialize(bundles = example_bundles1)
#'
#' #crack fhir resources
#' table_desc <- fhir_table_description(
#'     resource = "Patient",
#'     brackets = c("[", "]"),
#'     sep = " "
#' )
#'
#' df <- fhir_crack(bundles = bundles, design = table_desc)
#'
#' #find all column names associated with attribute address
#' col_names <- fhir_common_columns(df, "address")
#'
#' #original data frame
#' df
#'
#' #only keep address columns
#' fhir_melt(
#'      indexed_data_frame = df,
#'      columns            = col_names,
#'      brackets           = c("[", "]"),
#'      sep = " "
#'  )
#'
#' #keep all columns
#' fhir_melt(indexed_data_frame = df, columns = col_names,
#'           brackets = c("[","]"), sep = " ", all_columns = TRUE)
#' @export
#' @seealso [fhir_common_columns()], [fhir_rm_indices()]


fhir_melt <- function(
	indexed_data_frame,
	columns,
	brackets = c("<", ">"),
	sep = " ",
	id_name = "resource_identifier",
	all_columns = FALSE) {

	if(!is.data.frame(indexed_data_frame)) {
		stop(
			"You need to supply a data.frame or data.table to the argument indexed_data_frame.",
			"The object you supplied is of type ", class(indexed_data_frame), "."
		)
	}

	if(!all(columns %in% names(indexed_data_frame))) {
		stop("Not all column names you gave match with the column names in the data frame.")
	}

	indexed_dt <- copy(indexed_data_frame) #copy to avoid side effects
	is_DT <- data.table::is.data.table(x = indexed_dt)
	if(!is_DT) {data.table::setDT(x = indexed_dt)}
	brackets <- fix_brackets(brackets = brackets)

	indexed_dt[,(id_name):=1:nrow(indexed_dt)]

	expanded <- indexed_dt[, melt_row(.SD, columns = columns, brackets = brackets, sep = sep), by = eval((id_name)), .SDcols = columns]

	if(all_columns){
		rest <- setdiff(names(indexed_dt), columns)
		result <- merge.data.table(
			x = expanded,
			y = indexed_dt[, rest, with=FALSE],
			by = id_name,
			all = T
		)
		data.table::setcolorder(result, names(indexed_dt))
	}else{
		result <- expanded
	}

	if(nrow(result) == 0) {warning("The brackets you specified don't seem to appear in the indices of the provided data.frame. Returning NULL.")}

	if(!is_DT) {setDF(result)}
	result
}

#' Remove indices from data.frame/data.table
#'
#' Removes the indices in front of multiple entries as produced by [fhir_crack()] when brackets are provided in
#' the design.
#' @param indexed_data_frame A data frame with indices for multiple entries as produced by [fhir_crack()]
#' @param brackets A character vector of length two defining the brackets that were used in [fhir_crack()]
#' @param columns A character vector of column names, indicating from which columns indices should be removed.
#' Defaults to all columns.
#'
#' @return A data frame without indices.
#' @export
#'
#' @examples
#'
#' #unserialize example
#' bundles <- fhir_unserialize(bundles = example_bundles1)
#'
#' patients <- fhir_table_description(resource = "Patient")
#'
#' df <- fhir_crack(bundles = bundles,
#'                   design = patients,
#'                   brackets = c("[", "]"))
#'
#' df_indices_removed <- fhir_rm_indices(indexed_data_frame = df, brackets=c("[", "]"))
#'
#' @seealso [fhir_melt()]


fhir_rm_indices <- function(indexed_data_frame, brackets = c("<", ">"), columns = names( indexed_data_frame )) {
	if(!is.data.frame(indexed_data_frame)) {
		stop(
			"You need to supply a data.frame or data.table to the argument indexed_data_frame.",
			"The object you supplied is of type ", class(indexed_data_frame), "."
		)
	}
	indexed_dt <- copy(indexed_data_frame) #copy to avoid side effects
	is_DT <- data.table::is.data.table(x = indexed_dt)
	if(!is_DT) {data.table::setDT(x = indexed_dt)}
	brackets <- fix_brackets(brackets = brackets)
	brackets.escaped <- esc(s = brackets)
	pattern.ids <- stringr::str_c(brackets.escaped[1], "([0-9]+\\.*)*", brackets.escaped[2])
	if(!any(grepl(pattern.ids, indexed_dt))) {
		warning("The brackets you specified don't seem to appear in the data.frame.")
	}
	result <- data.table::data.table(gsub(pattern = pattern.ids, replacement = "", x = as.matrix(indexed_dt[,columns, with = FALSE])))
	indexed_dt[,columns] <- result
	if(!is_DT) {data.table::setDF(x = indexed_dt)}
	indexed_dt
}

########################################################################################
########################################################################################


#' Turn a row with multiple entries into a data frame
#'
#' @param row One row of an indexed data frame
#' @param columns A character vector specifying the names of all columns that should be molten simultaneously.
#' It is advisable to only melt columns simultaneously that belong to the same (repeating) attribute!
#' @param brackets A character vector of length 2, defining the brackets used for the indices.
#' @param sep A character vector of length one, the separator.
#' @param all_columns Return all columns? Defaults to `FALSE`, meaning only those specified in `columns` are returned.
#' @return A data frame with nrow > 1.
#' @noRd


melt_row <- function(row, columns, brackets = c("<", ">"), sep = " ") {
	row <- as.data.frame(row)
	brackets.escaped <- esc(s = brackets)
	pattern.ids <- stringr::str_c(brackets.escaped[1], "([0-9]+\\.*)+", brackets.escaped[2])
	ids <- stringr::str_extract_all(string = row, pattern = pattern.ids)
	names(ids) <- columns
	pattern.items <- stringr::str_c(brackets.escaped[1], "([0-9]+\\.*)+", brackets.escaped[2])
	items <- stringr::str_split(string = row, pattern = pattern.items)
	items <- lapply(
		items,
		function(i) {
			if(!all(is.na(i)) && i[1] == "") {i[2:length(i)]} else {i}
		}
	)
	names(items) <- columns
	d <- row[0,,drop=FALSE]
	data.table::setDF(d)

	for(i in names(ids)) {
		id <- ids[[i]]
		if(!all(is.na(id))) {
			it <- items[[i]]
			new.rows <- gsub(stringr::str_c(brackets.escaped[1], "([0-9]+)\\.*.*"), "\\1", id)
			new.ids <- gsub(stringr::str_c("(", brackets.escaped[1], ")([0-9]+)\\.*(.*", brackets.escaped[2], ")" ), "\\1\\3", id)
			unique.new.rows <- unique(new.rows)
			set <- stringr::str_c(new.ids, it)
			f <- sapply(
				unique.new.rows,
				function(unr) {
					fltr <- unr == new.rows
					stringr::str_c(set[fltr], collapse = "")
				}
			)
			for(n in unique.new.rows) {
				d[as.numeric(n), i]<- gsub(pattern = stringr::str_c(esc(sep), "$"), replacement = "", x = f[names(f) == n], perl = TRUE)
			}
		}
	}
	data.table::setDT(d)
}
