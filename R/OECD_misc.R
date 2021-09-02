#' Scraping tools for OECD related information.
#'
#' @param code Logical. If `TRUE`, prints the code to create the vector of
#' OECD countries to the console. `FALSE` by default, returns the whole
#' dataframe.
#'
#' @source https://en.wikipedia.org/wiki/OECD
#'
#' @details This family of functions returns information related to the OECD
#' such as the member States, the name and tenure period of the secretary-
#' generals of the OECD, etc. Data should be used carefully and not for
#' analytical purposes.
#'
#' @name oecd_misc
NULL
#> NULL

#' `oecd_members()`Scrapes member information of OECD countries from
#' Wikipedia and returns it in the form of a dataframe. This dataframe contains
#' member information such as accession dates, country names, etc.
#' @rdname oecd_misc
#' @examples
#' library(magrittr)
#' oecd_members()
#' @export

oecd_members <- function(code = FALSE) {
  # Step 1: Scrape
  oecd <- scrapeoecdwiki()[[6]]
  # Step 2: Clean
  oecd <- apply(oecd, 2, function(y) gsub("\\[.*\\]", "", y))
  colnames(oecd) <- lapply(colnames(oecd),
                           function(y) gsub("\\[.*\\]", "", y))
  oecd <- dplyr::as_tibble(oecd) %>%
    dplyr::mutate(dplyr::across(c(Application,
                                  Negotiations,
                                  Invitation,
                                  Membership),
                                anytime::anydate))
  # Add ID's
  oecd$ID <- countrycode::countrycode(oecd[["Country"]],
                                      "country.name",
                                      "iso3c")
  oecd <- dplyr::select(oecd, ID, dplyr::everything())
  # Step 3: Return
  if (code == TRUE) {
    oecdvec <- oecd$Country
    print(
      paste0("c('", paste(oecdvec, collapse = "', '"), "')")
    )
  } else {
    class(oecd) <- c("ifnotassigned", class(oecd))
    oecd
  }
}

#' `oecd_member_metrics()` Scrapes member information of OECD countries from
#' Wikipedia and returns it in the form of a dataframe. This dataframe contains
#' economic data of member countries. Not to be used for analysis purposes.
#' @rdname oecd_misc
#' @examples
#' library(magrittr)
#' oecd_member_metrics()
#' @export
oecd_member_metrics <- function() {
  # Step 1: Scrape
  oecd <- scrapeoecdwiki()[[7]]
  # Step 2: Clean
  oecd <- apply(oecd, 2, function(y) gsub("\\[.*\\]", "", y))
  colnames(oecd) <- lapply(colnames(oecd),
                          function(y) gsub("\\[.*\\]", "", y))
  # Replace commas with empty strings to convert to numeric
  oecd <- apply(oecd, 2, function(y) gsub(",", "", y))
  oecd <- dplyr::as_tibble(oecd) %>%
    dplyr::slice(1:(dplyr::n()-1)) %>%
    dplyr::na_if("N/A") %>%
    dplyr::mutate(Country=replace(Country, Country=="Korea South",
                             "South Korea")) %>%
    dplyr::mutate(dplyr::across(where(is.character) & !Country,
                                as.numeric))
  # Add ID's
  oecd$ID <- countrycode::countrycode(oecd[["Country"]],
                                              "country.name",
                                              "iso3c",
                                      custom_match = c("OECDbc" = "OCD"))
  oecd <- dplyr::select(oecd, ID, dplyr::everything())
  # Step 3: Return
  class(oecd) <- c("ifnotassigned", class(oecd))
  oecd
}

#' `oecd_secretary()` scrapes the table of previous OECD Secretary-Generals
#' from Wikipedia and returns a dataframe with their details.
#' @examples
#' library(magrittr)
#' oecd_secretary()
#' @rdname oecd_misc
#' @export
oecd_secretary <- function() {
  # Step 1: Scrape
  oecd <- scrapeoecdwiki()
  # Step 2: Tidy
  oecd <- dplyr::as_tibble(oecd[[5]]) %>%
    tidyr::separate(`Time served`, into = c("Beg", "End"), sep = " – ") %>%
    dplyr::mutate(Beg = anytime::anydate(Beg),
                  End = anytime::anydate(End),
                  ID = No.) %>%
    dplyr::select (-c("Notes", "No.")) %>%
    dplyr::select(ID, dplyr::everything())
  # Step 3: Complete
  oecd$End[[4]] <- anytime::anydate("1994-11-01")
  oecd$Beg[[5]] <- anytime::anydate("1994-11-01")
  oecd$End[length(oecd$End)] <- anytime::anydate(date())
  # Step 4: Add custom class with new print method if not assigned
  class(oecd) <- c("ifnotassigned", class(oecd))
  oecd
}

# Helper function to scrape all tables off of the OECD Wikipedia's page
scrapeoecdwiki <- function() {
  rvest::read_html("https://en.wikipedia.org/wiki/OECD") %>%
    rvest::html_nodes("table") %>%
    rvest::html_table(fill = TRUE)
}

# Helper function that prints the object if not assigned
print.ifnotassigned <- function(obj) {
  cat("message\n")
  NextMethod(obj)
}

