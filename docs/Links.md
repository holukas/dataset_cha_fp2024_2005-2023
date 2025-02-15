# Links

* **Jupyter notebooks** used to create the dataset can be found here: [https://github.com/holukas/dataset\_cha\_fp2024\_2005-2023/tree/main](https://github.com/holukas/dataset_cha_fp2024_2005-2023/tree/main)
* 
*   [Overview of processing progress on Google Docs](https://docs.google.com/spreadsheets/d/1KXaTtckHqOGULcr9nwL0FJ-xDnMJUFeDaXX8zh0fbJo/edit?usp=sharing) (binary conversion and Level-0 and Level-1 calculations), this sheet was used during processing
*   General overview of flux processing chain, explaining the different flux levels: [Flux Processing Chain](https://www.swissfluxnet.ethz.ch/index.php/data/ecosystem-fluxes/flux-processing-chain/)
*   Flux partitioning was done using [ReddyProc](https://github.com/EarthyScience/REddyProc) v1.3.3
* [bico](https://github.com/holukas/bico): Binary converter to convert original eddy covariance raw data files (irregular compressed binary files) to regular ASCII files. Used versions `v1.6.3` and `v1.6.5`.
* [fluxrun](https://github.com/holukas/fluxrun): Python wrapper for EddyPro. Used version `v1.4.1`.
* [diive](https://github.com/holukas/diive): Python library for (post-)processing time series data. Used for quality control, gap-filling, merging, etc. Used versions `v0.80+`.
