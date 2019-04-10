# -*- coding: utf-8 -*-
"""
Created on Mon Apr  8 16:28:43 2019

@author: W7SP1
"""
import pandas as pd
import os
import locale
import timeit
import random

locale.setlocale(locale.LC_CTYPE, 'bulgarian')

os.chdir("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens") 

idn = 17004985
runs = 10

SelRegions = {} 

SelRegions["Подуяне"] = 12
SelRegions["Надежда"] = 10

start = timeit.default_timer()

FullList = pd.read_csv("waiting.csv",encoding='windows-1251') 

FullList = FullList.loc[(FullList['born'] == 2017) &  (FullList['tail'] != "Хронични") & (FullList['id'] != idn), ]
FullList.reset_index(inplace=True,drop = True)

places = FullList[['kg','region','tail','places']].drop_duplicates()
places = pd.pivot_table(places, values = 'places', index=['kg','region'], columns = 'tail',fill_value=0).reset_index()
places.set_index('kg',inplace=True)

KgList = places.loc[places['region'].isin(["Подуяне"]),]
KgList = KgList['region'].to_dict()



class App:
    def __init__ (self, idn, points, kg, preference, tail, region, rn=None, admitted = 0):
        self.idn = idn
        self.points = points
        self.kg = kg
        self.preference = preference
        self.tail = tail 
        self.region = region
        self.rn = rn
        self.admitted = admitted

    
random.seed(400)  

list_apps = {}  

for key in KgList:

    apps = []    

    for i in range(1,len(FullList)):
        apps.append(App(idn = FullList.loc[i,'id'],
                        kg = FullList.loc[i, 'kg'],
                        points = FullList.loc[i,'points'],
                        preference = FullList.loc[i,'preference'],
                        tail = FullList.loc[i,'tail'],
                        region = FullList.loc[i,'region']))
        
    apps.append(App(idn = idn,
        kg = key,
        points = SelRegions[KgList[key]],
        preference = "",
        tail = "Общи",
        region = KgList[key]))

    for k in range(1, runs+1):
        places_loop = places.to_dict('index')
        for app in apps:
            app.rn = random.random()
        apps.sort(key=lambda x: (x.tail,-x.points,x.rn), reverse = False)      
        admitted = []
        for app in apps:
            if app.tail =="Социални":
               if places_loop[app.kg]['Социални']  >0:
                   if not app.idn in admitted:
                       app.admitted += 1 
                       admitted.append(app.idn)
                       places_loop[app.kg]['Социални'] -= 1
        
        for kg in places_loop:
            places_loop[kg]["Общи"]=places_loop[kg]["Общи"] + places_loop[kg]["Социални"]
            places_loop[kg]["Социални"] = 0
            
        for app in apps:
            if app.tail =="Общи":
               if places_loop[app.kg]['Общи']  >0:
                   if not app.idn in admitted:
                       app.admitted += 1 
                       admitted.append(app.idn)
                       places_loop[app.kg]['Общи'] -= 1
                       
    list_apps[key] = apps                       
                   
end = timeit.default_timer()
print(end-start)


for key,value in list_apps.items():
    chances = 0
    for app in value:
        if app.idn == idn:
            if app.admitted >0:
                chances+=app.admitted
    print("Вероятност за",key,chances/runs) 
