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

runs = 10

locale.setlocale(locale.LC_CTYPE, 'bulgarian')

os.chdir("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens") 

start = timeit.default_timer()

FullList = pd.read_csv("waiting.csv",encoding='windows-1251') 

FullList = FullList.loc[(FullList['born'] == 2017) &  (FullList['tail'] != "Хронични"), ]
FullList.reset_index(inplace=True,drop = True)

places = FullList[['kg','region','tail','places']].drop_duplicates()
places = pd.pivot_table(places, values = 'places', index=['kg','region'], columns = 'tail',fill_value=0).reset_index()
places.set_index('kg',inplace=True)

class App:
    def __init__ (self, idn, points, kg, preference, tail, region, rn=None, accepted = 0):
        self.idn = idn
        self.points = points
        self.kg = kg
        self.preference = preference
        self.tail = tail 
        self.region = region
        self.rn = rn
        self.accepted = accepted

apps = []    

for i in range(1,len(FullList)):
    apps.append(App(idn = FullList.loc[i,'id'],
                    kg = FullList.loc[i, 'kg'],
                    points = FullList.loc[i,'points'],
                    preference = FullList.loc[i,'preference'],
                    tail = FullList.loc[i,'tail'],
                    region = FullList.loc[i,'region']))
    
random.seed(400)    

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
                   app.accepted += 1 
                   admitted.append(app.idn)
                   places_loop[app.kg]['Социални'] -= 1
    
    for key in places_loop:
        places_loop[key]["Общи"]=places_loop[key]["Общи"] + places_loop[key]["Социални"]
        places_loop[key]["Социални"] = 0
        
    for app in apps:
        if app.tail =="Общи":
           if places_loop[app.kg]['Общи']  >0:
               if not app.idn in admitted:
                   app.accepted += 1 
                   admitted.append(app.idn)
                   places_loop[app.kg]['Общи'] -= 1
                   
end = timeit.default_timer()
print(end-start)


chances = 0
for app in apps:
    if app.idn == 17004985:
        if app.accepted >0:
            chances+=app.accepted
            print (app.kg,app.tail,app.preference,app.accepted/runs)
print("\nОбща вероятност",chances/runs)

  



