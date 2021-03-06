
requiredPackages = c('knitr','tidyr','dplyr','ggplot2','officer','magrittr','flextable')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}
setwd("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens")
Sys.setlocale("LC_CTYPE", "bulgarian")

path_to_report = "waiting.csv"


FullList <- read.csv("waiting.csv",stringsAsFactors = F)
FullList %>% summarise(n_distinct(id))

FullList_s <- FullList[FullList$tail == "��������",]
FullList$tail[FullList$tail=="��������"]="����"


Places <- read.csv("places.csv",stringsAsFactors = F)
Places_s <- Places[Places$tail=="��������",]
Places$tail[Places$tail=="��������"]="����"

Places <- Places %>% group_by(born, kg, region, tail) %>% summarise(places = sum(places))
Places_s <- Places_s %>% group_by(born, kg, region, tail) %>% summarise(places = sum(places))
x<-Places %>% group_by(born, region, tail) %>% summarise(sum(places)) %>% filter(tail == "����")
x<-Places %>% group_by(born, region, kg, tail) %>% summarise(sum(places)) %>% filter(region == "�������" & tail == "����" & born == 2017)


Applications <- FullList %>% 
  filter (preference == "3�. / (1-�� �������)") %>% 
  group_by(born, kg,region, tail) %>% 
  summarise(applications = n_distinct(id))

Fill %>%ungroup %>% summarise(sum(applications))

Fill <- merge(Places, Applications, by = c("born", "kg", "region", "tail"), all = T)
Fill$applications[is.na(Fill$applications)]<-0
Fill$places[is.na(Fill$places)]<-0

Applications_s <- FullList_s %>% 
  filter (preference == "3�. / (1-�� �������)") %>% 
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

FillByYear$tail[FillByYear$tail == "��������"]="� �.�. ��������"
FillByYear$tail[FillByYear$tail == "����"]="����"
FillByYear$tail[FillByYear$tail == "���"]="���"
FillByYear$tail[FillByYear$tail == "��������"]="�������� �."
table(FillByYear$tail)
FillByYear$tail <- factor(FillByYear$tail, levels = c("����", "� �.�. ��������", "���","�������� �."))
FillByYear <- FillByYear %>% arrange(desc(born),tail)

updated = ""

Fill <- Fill[Fill$tail!="��������",]

#region <-Fill %>% filter (tail == "����" & born == 2016) %>% 
region <-Fill %>% filter (born == 2016) %>% 
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
  scale_y_continuous(name="���� ���� �� ���� �����")+
  annotate("text", x = c(2), y = c(6.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")




#region <-Fill %>% filter (tail == "����" & born == 2017) %>% 
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
  scale_y_continuous(name="���� ���� �� ���� �����")+
  annotate("text", x = c(2), y = c(2.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")





#region <-Fill %>% filter (tail == "����" & born == 2018) %>% 
region <-Fill %>% filter (born == 2018) %>%   
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
  scale_y_continuous(name="���� ���� �� ���� �����")+
  annotate("text", x = c(2), y = c(5.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")

region <-Fill %>% filter (born == 2014) %>%   
  group_by(region) %>% 
  summarise(index = round(sum(applications)/sum(places),1), sum(places)) %>% 
  arrange( desc(index))

region$region <- factor(region$region, levels = region[order(region$index),]$region)


plot4 <- ggplot(region, aes(x=region, y =index,fill = index )) +
  geom_bar(stat="identity") + 
  scale_fill_gradient2(low="dark green", mid = "yellow" ,
                       high="dark red",midpoint = 3, name = "")+
  #scale_y_continuous(limits = c(0,8)) +
  coord_flip()+
  geom_text(aes(label=index), size =2.3,hjust=-0.25)+
  scale_x_discrete(name="")+
  scale_y_continuous(name="���� ���� �� ���� �����")+
  annotate("text", x = c(2), y = c(5.5), label = c(updated) , color="black", size=3 ,  fontface="bold")+
  theme(legend.position="none")

region <-Fill %>% filter (born == 2013) %>%   
  group_by(region) %>% 
  summarise(index = round(sum(applications)/sum(places),1), sum(places)) %>% 
  arrange( desc(index))

region$region <- factor(region$region, levels = region[order(region$index),]$region)


plot5 <- ggplot(region, aes(x=region, y =index,fill = index )) +
  geom_bar(stat="identity") + 
  scale_fill_gradient2(low="dark green", mid = "yellow" ,
                       high="dark red",midpoint = 3, name = "")+
  #scale_y_continuous(limits = c(0,8)) +
  coord_flip()+
  geom_text(aes(label=index), size =2.3,hjust=-0.25)+
  scale_x_discrete(name="")+
  scale_y_continuous(name="���� ���� �� ���� �����")+
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
  set_header_labels( born = "�����", tail = "������", Places = "�����", Apps = "���������", index = "���� �� 1 �����") %>%
  merge_v( j = 1, part = "body")%>%
  theme_vanilla() %>%
  width(c(2,4,5),1.1) %>%
  width(3, .8) %>%
  align( align = "right", j=5, part = "all") %>%
  italic(i=c(2,6,10,14,18), j = 2:5, italic = TRUE, part = "body")%>%
  padding(i=c(2,6,10,14,18), j = 2, padding = NULL, padding.top = NULL,
          padding.bottom = NULL, padding.left = 15, padding.right = NULL,
          part = "body")



ft

doc <- doc %>% 
  body_add_par("�������� �� ����� � ������ ������� � ���� �� ��������� 2019 - ��������� �� �����������*", style = "heading 1") %>% 
  body_add_par("*��������: �����", style = "Normal") %>% 
  body_add_par("", style = "heading 2") %>%
  body_add_par("���� ��������� � ����� � ����� ���������", style = "table title") %>%
  body_add_flextable(ft) %>% 
  body_add_par("", style = "heading 2") %>% 
  body_add_break()%>%
  body_add_par("���� ��������� � ����� �� ������ (������ ������) - ������� �� ���������� � ��������� �� ������� �� �������", style = "heading 2") %>% 
  body_add_par("������ 2018", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot3, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("������ 2017", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot2, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("������ 2016", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot1, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%
  body_add_par("������ 2014", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot4, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_break()%>%  
  body_add_par("������ 2013", style = "heading 3") %>% 
  body_add_par("", style = "Normal") %>% # blank paragraph
  body_add_gg(value = plot5, style = "centered" ) %>%
  body_add_par("", style = "Normal") %>% # blank paragraph


print(doc, target = "y.docx")


