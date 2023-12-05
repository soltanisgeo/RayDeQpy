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
    start = t1    
    end = cumsum[-1]
    target = start + ((end-start)*percentile)
    indx, val = find_nearest(array=cumsum, value=target)
    return indx

output_path='output'
lst=glob.glob('E:\RayDecC\data\AZP\*.sac')
lst=sorted(lst)
for f in lst:
    st = read(f)
    st.detrend("spline", order=3, dspline=500)
    st.filter('lowpass', freq=2)
    #
    tr = st[0]
    t1 = tr.stats.sac.t1
    t5 = tr.stats.sac.t5
    # plt.subplot(1, 3, 1)
    # plt.plot(tr.data)
    # plt.axvline(x=t1*100)
    # plt.axvline(x=t5*100)

    tr.trim(starttime=tr.stats.starttime+t1)
    # plt.subplot(1, 3, 2)
    # plt.plot(np.cumsum(tr.data**2))
    #
    indx = find_percentile_on_cumsum(array=tr.data, percentile=0.95)
    plt.axvline(x=indx)   
    t_coda=(2.3*(t5-t1))+t5
    tr.stats.sac.t6=float(indx)
    os.makedirs(output_path, exist_ok=True)
    tr.trim(starttime=tr.stats.starttime+tpts,
            endtime=tr.stats.starttime+indx)
    # plt.subplot(1, 3, 3)
    # plt.plot(tr.data)
   
    path = f.replace('E:\RayDecC\data\AZPfar', output_path)
    tr.write(path, format='SAC')