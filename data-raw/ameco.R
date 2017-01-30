library(tidyr) # gather()
library(dplyr) # starts_with()

# Get all files -----------------------------------------------------------

# Manually download zip from
# https://ec.europa.eu/info/files/all-zipped-text-files_en

temp_dir <- tempdir()
# temp_zip <- path/to/downloaded/zip
unzip(temp_zip, exdir = temp_dir)

files <- dir(temp_dir, "*.TXT", full.names = TRUE)

# Read files, bind together, clean, save ----------------------------------

all_files <- lapply(files, function(file) {
  read.table(file, TRUE, ";", fill = TRUE,
             stringsAsFactors = FALSE, strip.white = TRUE)
})

unlink(temp_dir, recursive = TRUE)

ameco <- do.call(rbind, all_files)
ameco <- tbl_df(ameco)
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
