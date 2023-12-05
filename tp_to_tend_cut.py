#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr  5 17:47:49 2022

@author: soltanis
"""

from obspy import read
import numpy as np
import matplotlib.pyplot as plt
import glob

def find_nearest(array, value):
    array = np.asarray(array)
    indx = (np.abs(array - value)).argmin()
    return indx, array[indx]
def find_percentile_on_cumsum(array, percentile=0.95):
    cumsum = np.cumsum(array**2)
    start = t1    
    end = cumsum[-1]
    target = start + ((end-start)*percentile)
    indx, val = find_nearest(array=cumsum, value=target)
    return indx

output_path='cum'
lst=glob.glob('./data/FAR/*.sac')
lst=sorted(lst)
for f in lst:
    st=read(f)
    tr=st[0]
    tr.detrend("spline", order=3, dspline=500)
    t1=tr.stats.sac.t1
    t5=tr.stats.sac.t5
    tpts=(2.3*(t5-t1))+t5
    tr.filter('lowpass', freq=2)
    # plt.subplot(1, 2, 1)
    # plt.plot(tr.data)
    # plt.axvline(x=t1*100)
    # plt.axvline(x=t5*100)
    # plt.axvline(x=tpts*100)
    
    tr.trim(tr.stats.starttime+t1,tr.stats.endtime)
   
   

    array =np.cumsum(tr.data)
    indx = find_percentile_on_cumsum(array=array, percentile=0.95)
    tr.stats.sac.t6=float(indx/100.0)+tpts
    tr.write(f.replace('data/FAR','cum'),format='SAC')
    # plt.axvline(x=indx/100.0+tpts)*100
    # plt.subplot(1, 2, 2)
    # plt.plot(np.cumsum(tr.data**2))
    
    