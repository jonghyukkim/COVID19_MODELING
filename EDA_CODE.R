
roaming_data <- fread("2. Roaming_data.csv")
roaming_data <- roaming_data %>%
  mutate(return = ymd(return) %>% as.POSIXct(),
         arrival = ymd(arrival) %>% as.POSIXct(),
         departure = ymd(departure) %>% as.POSIXct())

nation_code <- fread("국가코드.csv", encoding="UTF-8")

nation_code <- nation_code %>%
  mutate(국명 = str_remove(nation_code$국명, "<") %>% str_trim(side = "left"))

nation_code <- nation_code %>% rename(iso = `2자리`,
                                      nation= 국명) %>% mutate(iso = str_to_lower(iso)) %>% select(-`3자리`)

roaming_data <- left_join(roaming_data, nation_code, by = c("iso" = "iso"))

population <- fread("Population_for_challenge.csv")

covid_global <- fread("COVID-19-global-data.csv")
covid_global$Country <- str_to_lower(covid_global$Country) 

covid_global <- covid_global %>% rename(iso = Country)
covid_global %>% fwrite("covid_global.csv")

a <- roaming_data %>% 
  mutate(return = as.character(return)) %>% 
  group_by(iso, return) %>% 
  summarise(count = sum(count))

b <- covid_global %>% mutate(day = str_remove_all(day, pattern = "-"), iso=iso, Confirmed=Confirmed, Cumulative_confirmed = `Cumulative Confirmed`) %>% 
  select(day, iso, Confirmed, Cumulative_confirmed)

population$V3 <- NULL
population

a

roaming_data_new <- roaming_data %>%
  mutate(return = ymd(return) %>% as.POSIXct(),
         arrival = ymd(arrival) %>% as.POSIXct(),
         departure = ymd(departure) %>% as.POSIXct())


roaming_data_new %>% mutate(diff = lubridate::day(return - departure))


