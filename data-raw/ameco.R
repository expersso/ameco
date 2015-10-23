library(tidyr) # gather()
library(dplyr) # starts_with()

# Get all files -----------------------------------------------------------

temp_dir <- tempdir()
temp_zip <- tempfile(tmpdir = temp_dir, fileext = ".zip")

url <- "http://ec.europa.eu/economy_finance/db_indicators/ameco/documents/ameco0.zip"
download.file(url, temp_zip, mode = "wb")
unzip(temp_zip, exdir = temp_dir)

files <- dir(temp_dir, "*.TXT", full.names = TRUE)

# Read files, bind together, clean, save ----------------------------------

all_files <- lapply(files, function(file) {
  read.table(file, TRUE, ";", fill = TRUE,
             stringsAsFactors = FALSE, strip.white = TRUE)
})

ameco <- do.call(rbind, all_files)
ameco <- ameco[, -ncol(ameco)] # Drop stray/empty last column
names(ameco) <- tolower(names(ameco))

# Extract short country names
ameco$cntry <- regmatches(ameco$code,regexpr("^[[:alnum:]]+", ameco$code))

# Convert to long format
ameco <- gather(ameco, key = year, value = value, starts_with("x"))
ameco$year <- gsub("x", "", ameco$year)
ameco$year <- as.numeric(ameco$year)
ameco$value <- suppressWarnings(as.numeric(ameco$value))

save(ameco, file = "data/ameco.RData", compress = "xz")
