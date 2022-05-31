Title of the manuscript:

On assessing and improving the quality of dispersion images using the MASW technique for ground exploration

Authors:
Abdullah Talib, Jyant Kumar

Associated codes:

1. paper1_code_ss.m - This code generates the sythetic signal for the given/imported dispersion plot data. The number of geophones, source offset, geophone spacing, sampling frequency, frequency interval/total duration of signal can be defined within the code. The code plots the dispersion data and the synthetic signal also. 

2. paper1_code_di.m - This code generates the dispersion image data and plots the dispersion image for the given/imported signal data. The sampling frequency, source offset and geophone spacing used to generate the signal can be defined in the code.

3. paper1_code_qf.m - This code calculates the quality factor for the extracted modes at a particular frequency. The dispersion image data needs to be given or imported in the code. The velocity window over which scanning needs to be done for extracting the modes can be defined in the code (explained in code also). The threshold value of Wn can be defined in the code for extracting the modes. The code also plot the the values of wn showing different extracted modes above the threshold value. 

The two sample dispersion plot data is given in supplementary data; dispersion_plot_data_simple.mat and dispersion_plot_data_complex.mat. These two files can be used in the paper1_code_ss.m code to generate the synthetic signals.

The signal_data.mat file contains the data of signal for 48 geophones, source offset so = 5, geophone interval dx = 5 m, sampling frequency fs = 100 Hz. The data in the file can be used in paper1_code_di.m code to generate the dispersion image.

The dispersion_image_data.mat file contains the dispersion image data; normalizes amplitude array Wn, Amplitude array W, frequency vector f and velocity vector c. The data in this file can be used in paper1_code_qf.m code to calculate quality factor of different modes present in the dispersion image.