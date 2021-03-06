#' Automates sweary builds
#'
#' @description  It starts with rebuilding the `swear_words` data frame
#'   by running a prepared script. It lists all language files
#'   and constructs the data frame.
#'
#'   Then it rerenders the README.Rmd file so that all the proper
#'   numbers of new words and languages propagate into README.md.
#'   We also have to delete the README.html file that is created
#'   in the process.
#'
#'   The next step is to create necesarry documentation from
#'   roxygen comments.
#'
#'   Then we build the package as we would normally.
#'
#'   After a build, we run local tests that ensure our
#'   raw files consistency and check that the data frame
#'   `swear_words` has been modified accordingly.
#'
#'   The last step is a complex check.
#'
#'   Every error or warning should be properly addressed
#'   before merging into master.
#'
#' @return NULL
build_sweary <- function() {
	# Rebuild a swear_words data frame
	source("data-raw/swear-words.R")
	# Rerender the README file
	rmarkdown::render("README.Rmd", output_format = "github_document", encoding = "UTF-8")
	# Unlink a temporary preview HTML file
	unlink("README.html")
	# Rebuild documentation
	devtools::document(roclets = c("rd", "collate", "namespace"))
	# Rebuild package
	devtools::build()
	# Run local tests
	testthat::test_dir("data-raw/tests-local/")
	# Run complex package check
	devtools::check()
}
