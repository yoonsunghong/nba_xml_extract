library(XML)
library(xml2)
library(rvest)
library(magrittr)
library(stringr)
#this script aims to extract data from online using XML and related packages, generating dataframes (in csv) for each of the NBA teams.
# Assemble url (so it fits on screen)
basket <- "https://www.basketball-reference.com"
gsw <- "/teams/GSW/2017.html"
gsw_url <- paste0(basket, gsw)

# download HTML file to your working directory
download.file(gsw_url, 'gsw-roster-2017.html')

# Read GSW Roster html table
gsw_roster <- readHTMLTable('gsw-roster-2017.html')

nba_html <- paste0(basket, "/leagues/NBA_2017.html")

xml_doc <- read_html(nba_html)

# two html tables
xml_tables <- xml_doc %>%
  html_nodes("table") %>%
  extract(1:2)

# extract names of teams
xml_tables %>% 
  html_nodes("a") %>%
  html_text()

# href attributes
hrefs <- xml_tables %>% 
  html_nodes("a") %>%
  html_attr("href")

teams <- str_sub(hrefs, start = 8, end = 10)
files <- paste(teams, '-roster-2017', '.csv', sep = "")

# modify with `hrefs[1]`
basket <- "https://www.basketball-reference.com"
team_url <- paste0(basket, hrefs[1])
a <- read_html(team_url)
roster <- html_table(a)
write.csv(roster, "BOS-roster-2017.csv")

#creating a for loop for each team
for(i in 1:30) {
  team_url <- paste0(basket, hrefs[i])
  roster <- read_html(team_url) %>%
    html_table()
  write.csv(roster, files[i])
}



