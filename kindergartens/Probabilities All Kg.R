Sys.setlocale("LC_CTYPE", "bulgarian")
library(dplyr)

# library(doParallel) 
# library(snow)
# no_cores <- detectCores() - 1  
# cl <- makeCluster(no_cores, type="SOCK")  
# registerDoParallel(cl) 

setwd("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens")

FullList <- read.csv("waiting.csv",stringsAsFactors = F)

kg <- FullList %>%filter (born==2017)%>% select(region, kg, born) %>% distinct()
kg<- kg %>% filter(region %in% c("Кремиковци","Надежда"))
#kg<- kg %>% filter(region %in% c("Подуяне"))
#kg <- kg[c(8,10),]
kg$id = 17004985
kg$born = 2017
kg$tail = "Общи"
kg$places = 0
kg$points <- ifelse(kg$region == "Подуяне", 10, 8)

set.seed(3000)
#system.time(foreach(l=(1:nrow(kg))){
for (l in 1:nrow(kg)) {
  for (k in 1:20)  {
    FullList <- FullList %>% filter (born==2017) %>% select(id, kg, points, places, tail, born, region) 
    FullList_X <- FullList %>% filter(!id == 17004985)
    FullList_X <- rbind(FullList_X, kg[l,])
    
    FullList_X$rn <- runif(nrow(FullList_X))
    
    dat <- FullList_X %>% filter (tail == "Социални") %>% arrange(desc (points), rn)
    dat$admitted = 0
    
    places <- dat %>% group_by(kg) %>% summarise(places = max(places)) %>% ungroup
    admitted <- c()
    
    
    for (i in (1:nrow(dat))) {
      if (places$places[places$kg == dat[i, "kg"]] > 0 & !dat[i, "id"] %in% admitted) {
        dat[i, "admitted"] <- 1
        places$places[places$kg == dat[i, "kg"]] <- places$places[places$kg == dat[i, "kg"]] - 1
        admitted <- c(admitted, dat[i, "id"])
      }
    }
    
    
    admitted_s <- dat %>% filter(admitted==1) %>% select(id, kg) %>% distinct()
    
    dat <- FullList_X %>% filter (tail == "Общи") %>% arrange(desc (points), rn)
    dat$admitted = 0
    
    places <- rbind(dat %>% group_by(kg) %>% summarise(places = max(places)) %>% ungroup,places)
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
    
    admitted_o <- dat %>% filter(admitted==1) %>% select(id, kg) %>% distinct()
    
    ThisRunAdmitted <- data.frame("run" = k, rbind(admitted_s,admitted_o))
    
    if(exists("FullAdmitted")) {
      FullAdmitted<-rbind(FullAdmitted, ThisRunAdmitted)
    } else {
      FullAdmitted<- ThisRunAdmitted
    }
    
    rm(ThisRunAdmitted, admitted_s, admitted_o, places)
    
  }
  
  runs <- max(FullAdmitted$run)
  chances <- FullAdmitted %>% group_by(id) %>% summarise(proba = length(id)/runs)
  AllKids <- FullList_X[!duplicated(FullList_X$id),]
  
  chances <- merge(AllKids, chances, by= "id", all.x = T)[,c("id","proba")]
  chances[is.na(chances)]<-0
  chances <- chances %>% filter(id ==17004985)
  chances[,"kg"] <- FullList_X[nrow(FullList_X),"kg"]
  chances[,"region"] <- FullList_X[nrow(FullList_X),"region"]
  
  if(exists("AllKgChances")) {
    AllKgChances<-rbind(AllKgChances, chances)
  } else {
    AllKgChances<- chances
  }
  
  rm(FullAdmitted)
  print(l/nrow(kg))
  print(Sys.time())
}
