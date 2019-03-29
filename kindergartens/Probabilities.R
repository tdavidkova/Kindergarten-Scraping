Sys.setlocale("LC_CTYPE", "bulgarian")
library(dplyr)

setwd("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens")

FullList <- read.csv("waiting.csv",stringsAsFactors = F)

set.seed(100)

system.time(for (k in (1:100)){
  FullList <- FullList %>% filter (born==2017) %>% select(id, kg, points, places, tail,born)  
  FullList$rn <- runif(nrow(FullList))
  
  dat <- FullList %>% filter (tail == "????????????????") %>% arrange(desc (points), rn)
  dat$admitted = 0
  
  places <- dat %>% select(kg, places) %>% distinct()
  admitted <- c()
  
  
  for (i in (1:nrow(dat))) {
    if (places$places[places$kg == dat[i, "kg"]] > 0 & !dat[i, "id"] %in% admitted) {
      dat[i, "admitted"] <- 1
      places$places[places$kg == dat[i, "kg"]] <- places$places[places$kg == dat[i, "kg"]] - 1
      admitted <- c(admitted, dat[i, "id"])
    }
  }
  
  
  admitted_s <- dat %>% filter(admitted==1) %>% select(id, kg,points) %>% distinct()
  
  dat <- FullList %>% filter (tail == "????????") %>% arrange(desc (points), rn)
  dat$admitted = 0
  
  places <- rbind(dat %>% select(kg, places) %>% distinct(),places)
  places <- places %>% group_by (kg) %>% summarise(places = sum(places)) %>% ungroup
  
  for (i in (1:nrow(dat))) {
    if (places$places[places$kg == dat[i, "kg"]] > 0 & !dat[i, "id"] %in% admitted) {
      dat[i, "admitted"] <- 1
      places$places[places$kg == dat[i, "kg"]] <- places$places[places$kg == dat[i, "kg"]] - 1
      admitted <- c(admitted, dat[i, "id"])
    }
  }
  sum(dat$admitted)
  sum(places$places)
  
  admitted_o <- dat %>% filter(admitted==1) %>% select(id, kg,points) %>% distinct()
  
  ThisRunAdmitted <- data.frame("run" = k, rbind(admitted_s,admitted_o))
  
  if(exists("FullAdmitted")) {
    FullAdmitted<-rbind(FullAdmitted, ThisRunAdmitted)
  } else {
    FullAdmitted<- ThisRunAdmitted
  }
  
  rm(ThisRunAdmitted, admitted_s, admitted_o, places)
  
})

runs <- max(FullAdmitted$run)
chances <- FullAdmitted %>% group_by(id) %>% summarise(proba = length(id)/runs)
#x<-FullAdmitted %>% group_by(kg) %>% summarise(min(points))

chances %>% filter(id ==17002770)
FullAdmitted %>% filter(id ==17002770) %>% group_by(kg) %>% summarise(num = length(kg)/runs)
FullList %>% filter(id ==17002770) %>% select( kg,tail,points)
FullList %>%filter(!id %in% chances$id & born==2017) %>% summarise(num = n_distinct(id))
chances %>% summarise(num = n_distinct(id))
dat %>% filter(id ==17002770)
