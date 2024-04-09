# RayDeQpy

This repository contains the implementation of the RayDec method algorithm (Hobiger et al., 2009) applied to earthquake coda data.

## First Step: Coda Selection

Coda parts are selected following the method proposed by Perron et al. (2018). The coda is defined as the time interval from 𝑇𝑐𝑜𝑑𝑎 = 4.6(𝑇𝑆−𝑇𝑝)+𝑇0 to 𝑇𝑒𝑛𝑑, where 𝑇𝑝 and 𝑇𝑆 indicate the P and S wave arrival times, respectively. 𝑇𝑐𝑜𝑑𝑎 is the starting time of the coda, and 𝑇𝑒𝑛𝑑 corresponds to the time at which 95% of the cumulative energy (evaluated on the three components) between 𝑇𝑝 and the end of the record is reached.

### Steps and Codes

1. **Calculate Percentile**: Calculate the time corresponding to 95% of the cumulative energy evaluated on the three components between 𝑇𝑝 and the end of the record.
2. **Tcode_t_index_cut**: Index the extracted coda part.
3. **To Extract**: Extract the coda part using the above-mentioned criteria.

## Second Step: RayDec Method Algorithm

The RayDec (Rayleigh Wave Ellipticity by Using the Random Decrement Technique) method sums and stacks buffered signal time windows for the three components for various frequencies, where the time window length is frequency-dependent, typically 10 periods the frequency target. Specifically, for a given frequency, the method searches all time windows for which the first sample of the time window corresponding to the vertical component of the filtered signal changes its sign from negative to positive values.

### Steps and Codes

1. **Raydec.m**: The main function.
2. **Cecile_Raydec_2**: Helper function to run the code.

## Third Step: RayDec Plot

Raydec plot is a tool for plotting and comparing the results between raydec coda and raydec noise.

### Steps and Codes

1. **Raydecplotfinal.py**: Python script for plotting and comparing results.


## References

- Hobiger, M., et al. (2009). 
- Perron, V., et al. (2018). 

For more detailed information, please refer to the corresponding papers and documentation.

