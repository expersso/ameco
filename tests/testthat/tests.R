test_that("Test that current version is still latest version", {
  library(xml2)
  library(dplyr)

  url <- paste0("https://ec.europa.eu/info/business-economy-euro/indicators",
                "-statistics/economic-databases/macro-economic-database-ameco/",
                "download-annual-data-set-macro-economic-database-ameco_en")

  last_update <- url %>%
    read_html() %>%
    xml_find_all("//p[contains(text(), 'Last update')]") %>%
    xml_text() %>%
    sub("Last update: ", "", .) %>%
    as.Date("%d %b %Y")

  expect_equal(last_update, as.Date("2018-05-03"))
})