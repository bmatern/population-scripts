library(cbsodataR)
library(tidyverse)
library(sf)


# Find out which columns are available

metadata <- cbs_get_meta("83765NED")
print(metadata$DataProperties$Key)


# Download birth rates and delete spaces from regional identifiers

data <- cbs_get_data("83765NED", select=c("WijkenEnBuurten","GeboorteRelatief_25")) %>%
  mutate(WijkenEnBuurten = str_trim(WijkenEnBuurten), births = GeboorteRelatief_25)


# Retrieve data with municipal boundaries from PDOK

municipalBoundaries <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2017_gegeneraliseerd&outputFormat=json")


# Link data from Statistics Netherlands to geodata

data <-
  municipalBoundaries %>%
  left_join(data, by=c(statcode="WijkenEnBuurten"))


# (BM) Load a .csv of gemeente per Province
# Data is a combination of two:
# https://www.cbs.nl/nl-nl/onze-diensten/methoden/classificaties/overig/gemeentelijke-indelingen-per-jaar/gemeentelijke-indelingen-alfabetisch-en-numeriek/gemeenten-alfabetisch-per-provincie-2015/gemeenten-alfabetisch-per-provincie-2014
# https://nl.wikipedia.org/wiki/Lijst_van_Nederlandse_gemeenten
gemeente_map <- read.csv("2014-gemeenten-alfabetisch-per-provincie.csv")

# (BM) Convert the statcode (gemeente code) to an integer
statcodeint <- strtoi(str_replace(data$statcode,"GM",""),base=10)
data <- cbind(data, statcodeint)

# (BM) Join the province info into the data table
data <-
  data %>%
  left_join(gemeente_map, by=c(statcodeint="prov_Gemcode"))

# (BM) Load Donors per Province (from Martijn)
donors_per_province <- read.csv("DonorsPerProvince.csv")

# (BM) Join Donor Counts  per Province (from Martijn)
data <-
  data %>%
  left_join(donors_per_province, by=c(provcodel="Province"))


# Create a thematic map (using donor counts)

data %>%
  ggplot() +
  geom_sf(aes(fill = Donors)) +
  scale_fill_viridis_c() +
  labs(title = "Donors Per Province", fill = "") +
  theme_void()


