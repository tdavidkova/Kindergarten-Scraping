
requiredPackages = c('knitr','tidyr','dplyr','ggplot2','officer','magrittr','flextable')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}
setwd("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens")
Sys.setlocale("LC_CTYPE", "bulgarian")

path_to_report = "waiting.csv"


FullList <- read.csv("waiting.csv",stringsAsFactors = F)
FullList$tail[FullList$tail=="Социални"]="Общи"


Places <- read.csv("places.csv",stringsAsFactors = F)
Places$tail[Places$tail=="Социални"]="Общи"

Places <- Places %>% group_by(born, kg, region, tail) %>% summarise(places = sum(places))

Applications <- FullList %>% 
  filter (preference == "3т. / (1-во желание)") %>% 
  group_by(born, kg,region, tail) %>% 
  summarise(applications = n_distinct(id))

Fill <- merge(Places, Applications, by = c("born", "kg", "region", "tail"), all.x = T)
Fill$applications[is.na(Fill$applications)]<-0

format1 <- function(x){
  sprintf("%.1f", x)
}
FillByYear <- Fill %>% group_by(born,tail) %>% summarise(Places = sum(places), Apps = as.integer(sum(applications)))
FillByYear$index <- format1(FillByYear$Apps/FillByYear$Places) 

updated = "Данните са актуални към 1.5.19 13:52"


region <-Fill %>% filter (tail == "Общи" & born == 2016) %>% 
  group_by(region) %>% 
  summarise(index = round(sum(applications)/sum(places),1), sum(places)) %>% 
  arrange( desc(index))

region$region <- factor(region$region, levels = region[order(region$index),]$region)


plot1 <- ggplot(region, aes(x=region, y =index,fill = index )) +
  geom_bar(stat="identity") + 
  scale_fill_gradient2(low="dark green", mid = "yellow" ,
                       high="dark red",midpoint = 3, name = "")+
  #scale_y_continuous(limits = c(0,8)) +
  coord_flip()+
  geom_text(aes(label=index), size =2.3,hjust=-0.25)+
  scale_x_discrete(name="")+
  scale_y_continuous(name="")+
  annotate("text", x = c(2), y = c(6.5), label = c(updated) , color="black", size=3 ,  fontface="bold")




region <-Fill %>% filter (tail == "Общи" & born == 2017) %>% 
  group_by(region) %>% 
  summarise(index = round(sum(applications)/sum(places),1), sum(places)) %>% 
  arrange( desc(index))

region$region <- factor(region$region, levels = region[order(region$index),]$region)


plot2 <- ggplot(region, aes(x=region, y =index,fill = index )) +
  geom_bar(stat="identity") + 
  scale_fill_gradient2(low="dark green", mid = "yellow" ,
                       high="dark red",midpoint = 2, name = "")+
  #scale_y_continuous(limits = c(0,8)) +
  coord_flip()+
  geom_text(aes(label=index), size =2.3,hjust=-0.25)+
  scale_x_discrete(name="")+
  scale_y_continuous(name="")+
  annotate("text", x = c(2), y = c(2.5), label = c(updated) , color="black", size=3 ,  fontface="bold")




region <-Fill %>% filter (tail == "Общи" & born == 2018) %>% 
  group_by(region) %>% 
  summarise(index = round(sum(applications)/sum(places),1), sum(places)) %>% 
  arrange( desc(index))

region$region <- factor(region$region, levels = region[order(region$index),]$region)


plot3 <- ggplot(region, aes(x=region, y =index,fill = index )) +
  geom_bar(stat="identity") + 
  scale_fill_gradient2(low="dark green", mid = "yellow" ,
                       high="dark red",midpoint = 3, name = "")+
  #scale_y_continuous(limits = c(0,8)) +
  coord_flip()+
  geom_text(aes(label=index), size =2.3,hjust=-0.25)+
  scale_x_discrete(name="")+
  scale_y_continuous(name="")+
  annotate("text", x = c(2), y = c(5.5), label = c(updated) , color="black", size=3 ,  fontface="bold")

















#"template.docx"
system.file(package = "officer", "template/template.docx")


doc <- read_docx("template.docx") 
styles_info(doc)
doc_properties(doc)
set_doc_properties(doc,title = "Bla bla")

ft <- flextable(data = FillByYear) %>% 
  set_header_labels( born = "Набор", tail = "Критерии", Places = "Места", Apps = "Кандидати", index = "Деца за 1 място") %>%
  merge_v( j = 1, part = "body")%>%
  theme_vanilla() %>%
  width(c(2,4,5),1.1) %>%
  width(3, .8) %>%
  align( align = "right", j=5, part = "all")

ft

doc <- doc %>% 
  body_add_par("Кампания детски градини и ясли 2019", style = "heading 1") %>% 
  body_add_par("", style = "heading 2") %>%
  body_add_par("Брой кандидати и места в кампания 2019 (предв. данни)", style = "table title") %>%
  body_add_flextable(ft) %>% 
  body_add_par("", style = "heading 2") %>% 
  body_add_break()%>%
  body_add_par("Кандидати и места по общи критерии по райони", style = "heading 2") %>% 
  body_add_par("Родени 2016", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot1, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("Родени 2017", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot2, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("Родени 2018", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot3, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph

print(doc, target = "y.docx")


# doc <- doc %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "Normal") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "heading 1") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "heading 2") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "heading 3") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "centered") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "graphic title") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "table title") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "toc 1") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "toc 2") %>% 
#   body_add_par("Eaiiaiey aaonee a??aaeie e ynee 2019", style = "Balloon Text") 
#   