
# Get all files -----------------------------------------------------------

temp_zip <- tempfile(fileext = ".zip")
temp_dir <- tempdir()

url <- "http://ec.europa.eu/economy_finance/db_indicators/ameco/documents/ameco0.zip"
download.file(url, temp_zip, mode = "wb")
unzip(temp_zip, exdir = temp_dir)

files <- dir(temp_dir, "*.TXT", full.names = TRUE)

# Read files --------------------------------------------------------------

all_files <- lapply(files, function(file) {
  read.table(file, TRUE, ";", fill = TRUE,
             stringsAsFactors = FALSE, strip.white = TRUE)
})

df <- do.call(rbind, all_files)
df <- df[, -ncol(df)] # Drop stray/empty last column
names(df) <- tolower(names(df))

# Extract short country names
df$cntry <- regmatches(df$code,regexpr("^[[:alnum:]]+", df$code))

# Convert to long format
df <- gather(df, key = year, value = value, starts_with("x"))
df$year <- gsub("x", "", df$year)
df$year <- as.numeric(df$year)
df$value <- suppressWarnings(as.numeric(df$value))

save(df, file = "data/ameco.RData", compress = "xz")
