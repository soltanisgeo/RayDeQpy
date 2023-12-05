 -*- coding: utf-8 -*-
"""
Created on Tue Apr  5 11:07:11 2022

@author: soltanis
"""
from obspy import read
import numpy as np
import matplotlib.pyplot as plt
import glob
import os
output_path='output'
lst=glob.glob('./test/*.sac')
lst=sorted(lst)
for f in lst:
    st=read(f)
    tr=st[0]
    t1=tr.stats.sac.t1
def find_nearest(array, value):
    array = np.asarray(array)
    indx = (np.abs(array - value)).argmin()
    return indx, array[indx]
def find_percentile_on_cumsum(array, percentile=0.95):
    cumsum = np.cumsum(array**2)
    start = cumsum[t1]
    end = cumsum[-1]
    target = start + ((end-start)*percentile)
    indx, val = find_nearest(array=cumsum, value=target)
    return indx
    os.makedirs(output_path, exist_ok=True)
    tr.filter('lowpass', freq=2)
    array =np.cumsum(tr.data**2)
    indx = find_percentile_on_cumsum(array=array, percentile=0.95)
    print(indx)