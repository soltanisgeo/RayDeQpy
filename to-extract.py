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
import os

def find_nearest(array, value):
    array = np.asarray(array)
    indx = (np.abs(array - value)).argmin()
    return indx, array[indx]

def find_percentile_on_cumsum(array, percentile=0.95):
    cumsum = np.cumsum(array**2)
    start = cumsum[0]
    end = cumsum[-1]
    target = start + ((end-start)*percentile)
    indx, val = find_nearest(array=cumsum, value=target)
    return indx, val

output_path='output'
lst=glob.glob('F:\PROJECT2023\RayDecC project\RaydecC\data\DAR.02.068.18.24.20.1.sac')
lst=sorted(lst)
for f in lst:
    st = read(f)
    st.detrend("spline", order=3, dspline=500)
    st.filter('lowpass', freq=2)
    #
    tr = st[0]
    tp = tr.stats.sac.t1
    ts = tr.stats.sac.t5
    #
    st_filt = st.copy()
    st_filt.filter('lowpass', freq=2)
    tr_filt = st_filt[0]
    data1 = tr_filt.data
    time1 = tr_filt.times()
    #
    tr_for_cumsum = tr.slice(starttime=tr.stats.starttime+tp)
    indx, val = find_percentile_on_cumsum(array=tr_for_cumsum.data,
                                          percentile=0.95)
    t_coda = (2.3*(ts-tp)) + ts
    t_end = (indx * tr.stats.delta) + tp
  
    tr.stats.sac.t6 = t_end
    os.makedirs(output_path, exist_ok=True)
    
    tr_coda = tr_filt.trim(starttime=tr.stats.starttime+t_coda,
                           endtime=tr.stats.starttime+t_end+tp) 
    path = f.replace('E:\RaydecC\data\SUD', output_path)
    tr_coda.write(path, format='SAC')
    
    plt.subplot(3, 1, 1)
    plt.plot(time1, data1)
    plt.axvline(x=tp,     color='g', label='Tp',linewidth=2.5)
    plt.axvline(x=ts,     color='r', label='Ts',linewidth=2.5)
    plt.axvline(x=t_coda, color='m', label='Tcoda',linewidth=2.5)
    plt.axvline(x=t_end+tp,  color='k', label='Tend',linewidth=2.5)   
   
    plt.legend()
    
    plt.subplot(3, 1, 2)
    cumsum = np.cumsum(tr_for_cumsum.data**2)
    plt.plot(tr_for_cumsum.times(), cumsum/(max(cumsum))* 100)
    # plt.scatter(t_end, val/(max(cumsum))* 100)
    plt.axvline(x=0,     color='g', label='tp', linewidth=2.5)
    plt.axvline(x=t_end, color='k',  label='Tend', linewidth=2.5)
    plt.axhline(y=val/(max(cumsum))* 100, color='k')
    
    plt.subplot(3, 1, 3)
    plt.plot(tr_coda.times(), tr_coda)
    plt.axvline(x=0,     color='m', label='tp', linewidth=2.5)
    plt.axvline(x=409.84, color='k',  label='Tend', linewidth=2.5)
    plt.tight_layout()
    plt.show()
    # plt.savefig('filename.eps', format='eps')