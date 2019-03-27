# -*- coding: utf-8 -*-
"""
Created on Wed Mar 27 13:19:30 2019

@author: W7SP1
"""

import pandas as pd
import os
import locale
from locale import atof
import numpy
from numpy import random
import timeit



locale.setlocale(locale.LC_CTYPE, 'bulgarian')

os.chdir("C:/Documents/GitHub/Kindergarten-Scraping/kindergartens") 

FullList = pd.read_csv("waiting.csv",encoding='windows-1251') 

start = timeit.default_timer()
for k in range(0, 1):
    FullList = FullList.loc[FullList.born == 2017, ['id', 'kg','points','places','tail','born']]
    FullList['rn'] = numpy.random.uniform(size=len(FullList))
    
    dat = FullList[FullList['tail']== "Социални"].sort_values(['points', 'rn'], ascending=[0, 1])
    dat['admitted'] = 0
    
    places = dat[['kg','places']].drop_duplicates()
    places.reset_index(inplace=True,drop = True)
    dat.reset_index(inplace=True,drop = True)
    admitted = list()
    
    
    for i in range(0, len(dat)):
        if (places.loc[places['kg']==dat.loc[i,'kg'],'places'] >0).item() & (dat.loc[i,'id'] not in admitted):
            dat.loc[i, "admitted"] = 1
            places.loc[places['kg']==dat.loc[i,'kg'],'places'] = places.loc[places['kg']==dat.loc[i,'kg'],'places'] - 1
            admitted.append(dat.loc[i,'id'])
        
    admitted_s = dat.loc[dat['admitted']==1,['id','kg','points']].drop_duplicates()
    
    dat = FullList[FullList['tail']== "Общи"].sort_values(['points', 'rn'], ascending=[0, 1])
    dat['admitted'] = 0
    
    places = pd.concat([dat[['kg','places']].drop_duplicates(),places])
    places=places.groupby(['kg'])['places'].sum().reset_index()
    dat.reset_index(inplace=True,drop = True)
    
    for i in range(0, len(dat)):
        if (places.loc[places['kg']==dat.loc[i,'kg'],'places'] >0).item() & (dat.loc[i,'id'] not in admitted):
            dat.loc[i, "admitted"] = 1
            places.loc[places['kg']==dat.loc[i,'kg'],'places'] = places.loc[places['kg']==dat.loc[i,'kg'],'places'] - 1
            admitted.append(dat.loc[i,'id'])
     
    admitted_o = dat.loc[dat['admitted']==1,['id','kg','points']].drop_duplicates()
    ThisRunAdmitted=pd.concat([admitted_s,admitted_o])
    ThisRunAdmitted['run'] =1
    
        
    try:
        FullAdmitted
    except:
         FullAdmitted = ThisRunAdmitted
    else:
         FullAdmitted = pd.concat([FullAdmitted,ThisRunAdmitted])
    
    del([ThisRunAdmitted,admitted_s, admitted_o, places])
    


end = timeit.default_timer()
end-start

