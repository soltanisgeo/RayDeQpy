# RaydecC
I am going to apply the RayDec method algorithm (Hobiger et al., 2009) to earthquake coda data.

- First = Coda parts are selected following Perron et al. (2018) from (𝑇𝑐𝑜𝑑𝑎=4.6(𝑇𝑆−𝑇𝑝)+𝑇0 to 𝑇𝑒𝑛𝑑,  where Tp and Ts indicates the P and S wave time arrival, Tcoda the starting time of the coda and 𝑇𝑒𝑛𝑑 corresponds to the time for which 95% of the cumulative energy (evaluated on the three components) between 𝑇𝑝 and the end of the record is reached.
  
  Steps and codes :
  
1- Calculte Percentile = the time corresponding to 95% of the cumulated energy evaluated on the three components between TP and the end of the record.
  
2- Tcode_t_index_cut = to index the extracted coda part.

3- To extract = To extract the coda part using abovementioned criteria.



- Second = Applying the Raydec method alghoritm: The RayDec (Rayleigh Wave Ellipticity by Using the Random Decrement Technique) method sums and stacks buffered signal time windows for the three-components for various frequencies, time window length being frequency dependent, typically 10 periods the frequency target. More precisely, for a given frequency, the method searches all time windows for which the first sample of the time window corresponding to the vertical component of the filtered signal changes its sign from negative to positive values.

Steps and codes :
1- Raydec.m (the main function) and Cecile_Raydec_2(to run the code)


- Third = Raydec plot : a tool for plot and compare the results between raydec coda and raydec noise.

Steps and codes :
1- Raydecplotfinal.py


//

