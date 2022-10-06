print("hello world")
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


# Create a thematic map

data %>%
  ggplot() +
  geom_sf(aes(fill = births)) +
  scale_fill_viridis_c() +
  labs(title = "Levend geborenen per 1000 inwoners, 2017", fill = "") +
  theme_void()
