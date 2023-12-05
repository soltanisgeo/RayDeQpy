#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr  5 17:34:17 2022

@author: soltanis
"""

from obspy import read
import numpy as np
import matplotlib.pyplot as plt
import glob
import os

output_path='outputfinal'
lst=glob.glob('E:\Raydecc\cum\*.sac')
lst=sorted(lst)
for f in lst:
    st=read(f)
    tr=st[0]
    t1=tr.stats.sac.t1
    t5=tr.stats.sac.t5
    t_coda=(2.3*(t5-t1))+t5
    t6=tr.stats.sac.t6
    os.makedirs(output_path, exist_ok=True)
    tr.trim(tr.stats.starttime+t_coda,tr.stats.starttime+t6)
    tr.write(f.replace('data\cum','outputfinal'),format='SAC')
    # plt.subplot(1, 2, 2)
    # plt.plot(tr.data)    