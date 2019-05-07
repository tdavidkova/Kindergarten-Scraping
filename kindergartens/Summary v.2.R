
requiredPackages = c('knitr','tidyr','dplyr','ggplot2','officer','magrittr','flextable')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}
setwd("C:/Git/Kindergarten-Scraping/kindergartens")
Sys.setlocale("LC_CTYPE", "bulgarian")

path_to_report = "waiting.csv"


FullList <- read.csv("waiting.csv",stringsAsFactors = F)
FullList %>% summarise(n_distinct(id))

FullList_s <- FullList[FullList$tail == "Социални",]
FullList$tail[FullList$tail=="Социални"]="Общи"


Places <- read.csv("places.csv",stringsAsFactors = F)
Places_s <- Places[Places$tail=="Социални",]
Places$tail[Places$tail=="Социални"]="Общи"

Places <- Places %>% group_by(born, kg, region, tail) %>% summarise(places = sum(places))
Places_s <- Places_s %>% group_by(born, kg, region, tail) %>% summarise(places = sum(places))
x<-Places %>% group_by(born, region, tail) %>% summarise(sum(places)) %>% filter(tail == "Общи")
x<-Places %>% group_by(born, region, kg, tail) %>% summarise(sum(places)) %>% filter(region == "Младост" & tail == "Общи" & born == 2017)


Applications <- FullList %>% 
  filter (preference == "3т. / (1-во желание)") %>% 
  group_by(born, kg,region, tail) %>% 
  summarise(applications = n_distinct(id))

Fill %>%ungroup %>% summarise(sum(applications))

Fill <- merge(Places, Applications, by = c("born", "kg", "region", "tail"), all = T)
Fill$applications[is.na(Fill$applications)]<-0
Fill$places[is.na(Fill$places)]<-0

Applications_s <- FullList_s %>% 
  filter (preference == "3т. / (1-во желание)") %>% 
  group_by(born, kg,region, tail) %>% 
  summarise(applications = n_distinct(id))

Fill_s <- merge(Places_s, Applications_s, by = c("born", "kg", "region", "tail"), all = T)
Fill_s$applications[is.na(Fill_s$applications)]<-0
Fill_s$places[is.na(Fill_s$places)]<-0

Fill <- rbind(Fill, Fill_s)

format1 <- function(x){
  sprintf("%.1f", x)
}
FillByYear <- Fill %>% group_by(born,tail) %>% summarise(Places = sum(places), Apps = as.integer(sum(applications)))
FillByYear$index <- format1(FillByYear$Apps/FillByYear$Places) 

FillByYear$tail[FillByYear$tail == "Социални"]="в т.ч. социална"
FillByYear$tail[FillByYear$tail == "Общи"]="Обща"
FillByYear$tail[FillByYear$tail == "Соп"]="СОП"
FillByYear$tail[FillByYear$tail == "Хронични"]="Хронични б."
table(FillByYear$tail)
FillByYear$tail <- factor(FillByYear$tail, levels = c("Обща", "в т.ч. социална", "СОП","Хронични б."))
FillByYear <- FillByYear %>% arrange(desc(born),tail)

updated = ""

Fill <- Fill[Fill$tail!="Социални",]

#region <-Fill %>% filter (tail == "Общи" & born == 2016) %>% 
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
  scale_y_continuous(name="Брой деца за едно място")+
  annotate("text", x = c(2), y = c(6.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")




#region <-Fill %>% filter (tail == "Общи" & born == 2017) %>% 
region <-Fill %>% filter (born == 2017) %>% 
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
  scale_y_continuous(name="Брой деца за едно място")+
  annotate("text", x = c(2), y = c(2.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")





#region <-Fill %>% filter (tail == "Общи" & born == 2018) %>% 
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
  scale_y_continuous(name="Брой деца за едно място")+
  annotate("text", x = c(2), y = c(5.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")





















#"template.docx"
system.file(package = "officer", "template/template.docx")


doc <- read_docx("template.docx") 
styles_info(doc)
doc_properties(doc)
set_doc_properties(doc,title = "Bla bla")

FillByYear$Places<-as.integer(FillByYear$Places)

ft <- flextable(data = FillByYear) %>% 
  set_header_labels( born = "Набор", tail = "Опашка", Places = "Места", Apps = "Кандидати", index = "Деца за 1 място") %>%
  merge_v( j = 1, part = "body")%>%
  theme_vanilla() %>%
  width(c(2,4,5),1.1) %>%
  width(3, .8) %>%
  align( align = "right", j=5, part = "all") %>%
  italic(i=c(2,6,10), j = 2:5, italic = TRUE, part = "body")%>%
  padding(i=c(2,6,10), j = 2, padding = NULL, padding.top = NULL,
          padding.bottom = NULL, padding.left = 15, padding.right = NULL,
          part = "body")



ft

doc <- doc %>% 
  body_add_par("Кампания детски градини и ясли май 2019", style = "heading 1") %>% 
  body_add_par("", style = "heading 2") %>%
  body_add_par("Брой кандидати и места в кампания 2019/2020", style = "table title") %>%
  body_add_flextable(ft) %>% 
  body_add_par("", style = "heading 2") %>% 
  body_add_break()%>%
  body_add_par("Брой кандидати и места по райони (всички опашки) - районът на кандидтите е определен по първото им желание", style = "heading 2") %>% 
  body_add_par("Родени 2018", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot3, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("Родени 2017", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot2, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("Родени 2016", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot1, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph


print(doc, target = "y.docx")


