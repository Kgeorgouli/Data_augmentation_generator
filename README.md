# Data augmentation generator
Data augmentation generator is a data augmentation solution to increase the performance of a classification model by generating realistic data augmented samples.

### Usage:
  ```synsamples = data_augmentation_generator( sample1, sample2, per, yaxis_intensifier, xaxis_shift_samples, wavelengths, gaussiansnr, gaussian_samples)``` 
 
**Input**:

 `sample1` - Main sample spectrum (Array 1xN, N is the number of
             wavelengths/wavenumbers)  
 `sample2` - Second sample spectrum for the blender block (Array 1xN)  
 `per` - concentration grades for the blender block (Array)  
 `yaxis_intensifier` - amplification factor for spectral intensifier  
 `xaxis_shift_samples` - number of samples produced by shifting
                         along x axis block  
 `wavelengths` - wavelengths/wavenumbers of the spectra needed
                 for the shifting along x axis block (Array 1xN)  
 `gaussiansnr` - Gaussian noise signal-to-noise ratio per spectrum, in dB  
 `gaussian_samples` - number of samples produced by adding noise
                      block
              
 **Output**:
 
 `synsamples` - the generated spectra.   

### Examples:
1. This example makes use of the blender block where sample1 and sample2 are used for generating artificial admixtures for `per` different concentration grades (weighted sum of the input samples).
```
per = [0.16,0.18,0.20,0.40,0.60,0.70,0.80,0.82,0.84];
new_samples = data_augmentation_generator(sample1,sample2,per,0,0,[],0,0); 
```
2. The following example generates 33 data augmented samples of sample1 by applying spectral intensifier: M= 1.01 to 1.33 with a step of 0.01, shifting along x-axis: Laplacian distribution with b = 0.6 (20 samples), and noise: 10 samples with 35 dB Gaussian noise.  

```new_samples = data_augmentation_generator(sample1,[],[],33,20,wavelengths,35,10);```

If you use data augmentation generator we would appreciate a citation to:

[Georgouli, K., Osorio, M.T., Martinez Del Rincon, J. and Koidis, A., 2018. Data augmentation in food science: Synthesising spectroscopic data of vegetable oils for performance enhancement. Journal of Chemometrics, 32(6), p.e3004.](https://onlinelibrary.wiley.com/doi/full/10.1002/cem.3004?casa_token=2nxP1jZQdssAAAAA%3AZKK6sp65Uz1PsfCD5oJEqUP9vIyaJ1LkGbFPEagIQMuDNCnQYm2WceB0dB_tLzRi5pqUWkc43yALAYw)

