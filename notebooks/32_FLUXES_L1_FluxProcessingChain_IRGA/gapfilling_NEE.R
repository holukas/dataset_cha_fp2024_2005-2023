# CH-AWS
# Post-processing script for PI dataset CH-AWS_FP2022_2015-2021

# Script for USTAR threshold detection
# All NEE_QCF01 values were already quality-checked, with daytime data of high or OK quality (QCF = 0 or 1)
# and with nighttime data comprising values with high quality (QCF = 0) only.
# while for daytime data QCF = 0 and QCF = 1 were used.
# All LE_QCF01 values were already quality-checked and comprise values with quality flag
# QCF = 0 and QCF = 1 for *both* daytime and nighttime data.

library(ggplot2)
library(REddyProc)
library(caTools)
library(dplyr)
library(viridis)
library(readr)
library(segmented)



# RUN ID
run_id <- format(Sys.time(), "%Y%m%d%H%M%S",tz="GMT")   ## To give unique ID to saved output files



# SOURCE FILE 
# =========== 
file_fluxes_meteo <- "C:/Users/holukas/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/32_FLUXES_L1_FluxProcessingChain_IRGA/32.7_FluxProcessingChain_L3.3_fluxesSwinTaVpd_subsetForREddyProc.csv"
output_path <- getwd()
Sys.setenv(TZ = "GMT")



# DATA FROM FILE
# ==============
filedata <- read.csv(file_fluxes_meteo, header = 1)
filedata$TIMESTAMP <- as.POSIXct(filedata$TIMESTAMP_END, format="%Y-%m-%d %H:%M:%S")
summary(filedata)
head(filedata)
colnames(filedata)



# DATA COLUMNS
# ============
EddyData.F <- filedata[FALSE]
EddyData.F$TIMESTAMP <- as.POSIXct(filedata$TIMESTAMP, format = '%m/%d/%Y %H:%M', tz = Sys.timezone())

# Vars for gap-filling
EddyData.F$NEE_CUT_16 <- as.numeric(as.character(filedata$NEE_L3.1_L3.3_CUT_16_QCF))
EddyData.F$NEE_CUT_50 <- as.numeric(as.character(filedata$NEE_L3.1_L3.3_CUT_50_QCF))
EddyData.F$NEE_CUT_84 <- as.numeric(as.character(filedata$NEE_L3.1_L3.3_CUT_84_QCF))
EddyData.F$LE <- as.numeric(as.character(filedata$LE_L3.1_L3.3_CUT_NONE_QCF))
EddyData.F$H <- as.numeric(as.character(filedata$H_L3.1_L3.3_CUT_NONE_QCF))
EddyData.F$Rg <- as.numeric(as.character(filedata$SW_IN_T1_2_1))
EddyData.F$Tair <- as.numeric(as.character(filedata$TA_T1_2_1))
EddyData.F$VPD <- as.numeric(as.character(filedata$VPD_T1_2_1))
EddyData.F$VPD[EddyData.F$VPD < 0] <- NA  # To remove -9999 missing values
EddyData.F$VPD <- EddyData.F$VPD * 10
summary(EddyData.F$VPD)

# Restrict time range
EddyData.F <- subset (EddyData.F, TIMESTAMP >= as.POSIXct('2005-01-01 00:30:00'))  # Date with first fluxes
EddyData.F <- subset (EddyData.F, TIMESTAMP <= as.POSIXct('2024-01-01 00:00:00'))

summary(EddyData.F)



# Initialize R5 reference class
# ============================
EddyProc.C <-sEddyProc$new('CH-CHA',  EddyData.F,
                           c('NEE_CUT_16','NEE_CUT_50','NEE_CUT_84','LE','H','Rg','Tair','VPD'), ColPOSIXTime = "TIMESTAMP")   
EddyProc.C$sSetLocationInfo(LatDeg = 47.210227, LongDeg = 8.410645, TimeZoneHour = 1)  # CH-CHA coordinates
str(EddyProc.C)
head(EddyProc.C$sDATA)
head(EddyProc.C$sTEMP)


## LE w/o USTAR THRESHOLD
## ----------------------
## (QC=0 and QC=1)
EddyProc.C$sMDSGapFill('NEE_CUT_16', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('NEE_CUT_50', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('NEE_CUT_84', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('LE', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('H', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Tair', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Rg', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('VPD', FillAll = FALSE, isVerbose = TRUE)


## ET
## --
## Calculate ET from LE (QC=0 and QC=1)
EddyProc.C$sTEMP$ET_f <- fCalcETfromLE(EddyProc.C$sTEMP$LE_f, EddyProc.C$sDATA$Tair)


summary(EddyProc.C$sTEMP)



# PARTITIONING
# ============
EddyProc.C$sMRFluxPartition(FluxVar = 'NEE_CUT_16_f', QFFluxVar = 'NEE_CUT_16_fqc', suffix = 'CUT_16')
EddyProc.C$sMRFluxPartition(FluxVar = 'NEE_CUT_50_f', QFFluxVar = 'NEE_CUT_50_fqc', suffix = 'CUT_50')
EddyProc.C$sMRFluxPartition(FluxVar = 'NEE_CUT_84_f', QFFluxVar = 'NEE_CUT_84_fqc', suffix = 'CUT_84')

EddyProc.C$sGLFluxPartition(NEEVar = 'NEE_CUT_16_f', suffix = 'CUT_16')
EddyProc.C$sGLFluxPartition(NEEVar = 'NEE_CUT_50_f', suffix = 'CUT_50')
EddyProc.C$sGLFluxPartition(NEEVar = 'NEE_CUT_84_f', suffix = 'CUT_84')



# COLLECT DATA AND EXPORT
# =======================
cat("Export data to standard data frame ...")
FilledEddyData.F <- EddyProc.C$sExportResults()
FilledEddyData.F$TIMESTAMP          <-EddyData.F$TIMESTAMP
write.csv(FilledEddyData.F, file = paste("C:/Users/holukas/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/32_FLUXES_L1_FluxProcessingChain_IRGA/32.9_CH-CHA_NEE-GPP-RECO-LE-ET-H_L4.2_", run_id,".csv",sep="")) 






# grep("GPP|Reco",names(EddyProc.C$sExportResults()), value = TRUE)
# EddyProc.C$sPlotFingerprintY('GPP_f', Year = 1997)

# grep("_DT",names(EddyProc.C$sExportResults()), value = TRUE)
# EddyProc.C$sPlotFingerprintY('Reco', Year = 2004)



# PLOTS
# =====
# Save fingerprint plots as PDF
EddyProc.C$sPlotFingerprint('NEE_CUT_16_f')
EddyProc.C$sPlotFingerprint('NEE_CUT_50_f')
EddyProc.C$sPlotFingerprint('NEE_CUT_84_f')

EddyProc.C$sPlotFingerprint('GPP_CUT_16_f')
EddyProc.C$sPlotFingerprint('GPP_CUT_50_f')
EddyProc.C$sPlotFingerprint('GPP_CUT_84_f')

EddyProc.C$sPlotFingerprint('GPP_DT_CUT_16')
EddyProc.C$sPlotFingerprint('GPP_DT_CUT_50')
EddyProc.C$sPlotFingerprint('GPP_DT_CUT_84')

EddyProc.C$sPlotFingerprint('Reco_CUT_16')
EddyProc.C$sPlotFingerprint('Reco_CUT_50')
EddyProc.C$sPlotFingerprint('Reco_CUT_84')

EddyProc.C$sPlotFingerprint('Reco_DT_CUT_16')
EddyProc.C$sPlotFingerprint('Reco_DT_CUT_50')
EddyProc.C$sPlotFingerprint('Reco_DT_CUT_84')


EddyProc.C$sPlotFingerprint('LE_f')
EddyProc.C$sPlotFingerprint('ET_f')
EddyProc.C$sPlotFingerprint('Tair_f')
EddyProc.C$sPlotFingerprint('Rg_f')
EddyProc.C$sPlotFingerprint('VPD_f')



# PLOT PER YEAR
# =============

FilledEddyData.F = FilledEddyData.F %>% mutate(
  Date = as.Date(TIMESTAMP,'%Y-%m-%d'), 
  Time = as.character(format(TIMESTAMP, '%H:%M')),
  Year = as.numeric(format(TIMESTAMP,'%Y')))

# NEE, GPP, RECO
# --------------
for (Yr in c(2005:2023))
{
  Year_Filled_Eddy_Data = FilledEddyData.F %>% filter(Year == Yr)
  summary(Year_Filled_Eddy_Data$TIMESTAMP)
  
  a = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = NEE_CUT_50_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('NEE') + theme(axis.text.x=element_blank())
  
  b = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = GPP_CUT_50_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('GPP (nighttime partitioning)') + theme(axis.text.x=element_blank())
  
  c = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Reco_CUT_50)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('RECO (nighttime partitioning)') + theme(axis.text.x=element_blank())  
  
  d = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = GPP_DT_CUT_50)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('GPP (daytime partitioning)') + theme(axis.text.x=element_blank())
  
  e = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Reco_DT_CUT_50)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('RECO (daytime partitioning)') + theme(axis.text.x=element_blank())    
  
  gr = gridExtra::arrangeGrob(a,b,c,d,e, ncol = 5)
  
  ggsave(paste(as.character(Yr),"_CH-CHA_NEE_GPP_RECO_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
  print(summary(Year_Filled_Eddy_Data$TIMESTAMP))
  print(Yr)
}


# NEE, LE, ET
# -----------
for (Yr in c(2005:2023))
{
  Year_Filled_Eddy_Data = FilledEddyData.F %>% filter(Year == Yr)
  summary(Year_Filled_Eddy_Data$TIMESTAMP)
  
  a = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = NEE_CUT_50_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('NEE') + theme(axis.text.x=element_blank())
  
  b = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = LE_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('LE') + theme(axis.text.x=element_blank())
  
  c = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = ET_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('ET') + theme(axis.text.x=element_blank())
  
  gr = gridExtra::arrangeGrob(a,b,c, ncol = 3)
  
  ggsave(paste(as.character(Yr),"_CH-CHA_NEE_LE_ET_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
  print(summary(Year_Filled_Eddy_Data$TIMESTAMP))
  print(Yr)
}



# SW_IN, TA, VPD
# --------------
for (Yr in c(2005:2023))
{
  Year_Filled_Eddy_Data = FilledEddyData.F %>% filter(Year == Yr)
  summary(Year_Filled_Eddy_Data$TIMESTAMP)
  
  a = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Rg_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('SW_IN') + theme(axis.text.x=element_blank())
  
  b = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Tair_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('TA') + theme(axis.text.x=element_blank())
  
  c = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = VPD_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('VPD') + theme(axis.text.x=element_blank())
  
  gr = gridExtra::arrangeGrob(a,b,c, ncol = 3)
  
  ggsave(paste(as.character(Yr),"_CH-CHA_SWIN_TA_VPD_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
  print(summary(Year_Filled_Eddy_Data$TIMESTAMP))
  print(Yr)
}







# DAILY AGGREGATION
# =================

## While daily aggregation only choosing QC = 0 and 1
FilledEddyData.F_daily = FilledEddyData.F %>% group_by(Date) %>% 
  summarise(NEE_CUT_50_f_mean = mean(NEE_CUT_50_f),
            GPP_CUT_50_f_mean = mean(GPP_CUT_50_f),
            Reco_CUT_50_mean = mean(Reco_CUT_50),
            GPP_DT_CUT_50_mean = mean(GPP_DT_CUT_50),
            Reco_DT_CUT_50_mean = mean(Reco_DT_CUT_50),
            LE_f_mean = mean(LE_f),
            ET_f_mean = mean(ET_f),
            VPD_f_mean = mean(VPD_f),
            TA_mean = mean(Tair_f),
            SW_IN_mean = mean(Rg_f)) %>% 
  mutate(Year = as.numeric(format(Date, '%Y')), Month = as.numeric(format(Date,'%m')), DOY = as.numeric(format(Date,'%j')))

summary(FilledEddyData.F_daily)

# write.csv(FilledEddyData.F_daily, 'CH_AWS_LE_ET_VPD_TA_SW_IN_daily.csv', row.names = FALSE)

## Plotting daily Fluxes

a = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = NEE_CUT_50_f_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('NEE_f_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

b = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = GPP_CUT_50_f_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('GPP_f_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

c = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = Reco_CUT_50_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('RECO_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

d = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = GPP_DT_CUT_50_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('GPP_DT_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

e = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = Reco_DT_CUT_50_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('RECO_DT_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

f = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = LE_f_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('LE_f_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

g = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = ET_f_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('ET_f_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

h = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = VPD_f_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('VPD_f_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

i = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = TA_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('TA_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

j = ggplot(FilledEddyData.F_daily, aes(x = DOY, y = Year, fill = SW_IN_mean)) + geom_tile() + scale_fill_viridis(option = "D") +
  ggtitle('SW_IN_mean daily gapfilled') + theme(axis.text.x=element_blank()) + theme_bw()

gr = gridExtra::arrangeGrob(a,b,c,d,e,f,g,h,i,j, ncol = 5)

ggsave("CH-CHA_DOY_Daily.png", gr ,height = 300, width =600, units = 'mm')


#############------------------------------ End of Script --------------------------------------------------------------------##################
### Thank you for your patience.

