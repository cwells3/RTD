#' @include import.R table.R
NULL

#' Upload data.frame to TD
#'
#' @param dbname Target destination database name.
#' @param table Target table name.
#' @param df Input data.frame
#' @param overwrite Flag for overwriting the table if exists
#'
#' @importFrom readr write_tsv
#' @export
copy_to <- function(dbname, table, df, overwrite = FALSE) {
  is_exist_table <- table_exists(dbname, table)
  if(!overwrite && is_exist_table) {
    stop(paste0('"', dbname, ".", table, '" is already exists.'))
  }
  if(overwrite) {
    table_delete(dbname, table)
  }
  table_create(dbname, table)

  tmpfname <- tempfile(fileext = ".tsv")
  write_tsv(df, tmpfname, quote_escape = FALSE)
  import_auto(paste0(dbname, ".", table), tmpfname, format = 'tsv')
}