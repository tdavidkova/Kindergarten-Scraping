Sys.setlocale("LC_CTYPE", "bulgarian")
##### SAVE WITH ENCODING MS-CYRL

library(dplyr)
library(snow)
library(Hmisc)
library(parallel)
library(doParallel)

numCores <- detectCores()
numCores

cl <- makeCluster(numCores)
registerDoParallel(cl)


setwd("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens")

FullList <- read.csv("waiting.csv",stringsAsFactors = F)

set.seed(100)

runonce <- function(k) {
  FullList <- FullList %>% filter (born==2017) %>% select(id, kg, points, places, tail,born)  
  FullList$rn <- runif(nrow(FullList))
  
  dat <- FullList %>% filter (tail == "Социални") %>% arrange(desc (points), rn)
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
  
  dat <- FullList %>% filter (tail == "Общи") %>% arrange(desc (points), rn)
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

  
  admitted_o <- dat %>% filter(admitted==1) %>% select(id, kg,points) %>% distinct()
  
  ThisRunAdmitted <- data.frame("run" = k, rbind(admitted_s,admitted_o))

  return(ThisRunAdmitted)

  
  rm(ThisRunAdmitted, admitted_s, admitted_o, places)
}


#system.time(x<-apply(1:4,runonce))
clusterExport(cl,list("FullList"))

system.time(FullAdmitted <-foreach (k = 1:100, .combine = rbind) %dopar% {
  Sys.setlocale("LC_CTYPE", "bulgarian")
  library(dplyr)
  runonce(k)}
  )


stopCluster(cl) 


runs <- max(FullAdmitted$run)
chances <- FullAdmitted %>% group_by(id) %>% summarise(proba = length(id)/runs)
#x<-FullAdmitted %>% group_by(kg) %>% summarise(min(points))

chances %>% filter(id ==17004985)
FullAdmitted %>% filter(id ==17004985) %>% group_by(kg) %>% summarise(num = length(kg)/runs)
FullList %>% filter(id ==17002770) %>% select( kg,tail,points)
FullList %>%filter(!id %in% chances$id & born==2017) %>% summarise(num = n_distinct(id))
chances %>% summarise(num = n_distinct(id))
dat %>% filter(id ==17002770)
