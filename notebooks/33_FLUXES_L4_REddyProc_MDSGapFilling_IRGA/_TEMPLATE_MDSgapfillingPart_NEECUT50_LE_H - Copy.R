# CH-CHA
# Gap-filling for NEE, LE and H fluxes

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
file_fluxes_meteo <- "L:/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/32_FLUXES_L1_FluxProcessingChain_IRGA/32.9_FluxProcessingChain_L3.3_subset-forREddyProcGapFilling.csv"
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
EddyData.F$NEE_CUT_50 <- as.numeric(as.character(filedata$NEE_L3.1_L3.3_CUT_50_QCF))
EddyData.F$LE <- as.numeric(as.character(filedata$LE_L3.1_L3.3_CUT_NONE_QCF))
EddyData.F$H <- as.numeric(as.character(filedata$H_L3.1_L3.3_CUT_NONE_QCF))
EddyData.F$Rg <- as.numeric(as.character(filedata$SW_IN_T1_2_1))
EddyData.F$Tair <- as.numeric(as.character(filedata$TA_T1_2_1))
EddyData.F$VPD <- as.numeric(as.character(filedata$VPD_T1_2_1))
EddyData.F$VPD[EddyData.F$VPD < 0] <- NA  # To remove -9999 missing values
EddyData.F$VPD <- EddyData.F$VPD * 10  # Convert from kPa to hPa
summary(EddyData.F$VPD)

# Restrict time range
EddyData.F <- subset (EddyData.F, TIMESTAMP >= as.POSIXct('2005-01-01 00:30:00'))  # Date with first fluxes
EddyData.F <- subset (EddyData.F, TIMESTAMP <= as.POSIXct('2024-01-01 00:00:00'))
summary(EddyData.F)


# Initialize R5 reference class
# ============================
EddyProc.C <-sEddyProc$new('CH-CHA',  EddyData.F,
                           c('NEE_CUT_50','LE','H','Rg','Tair','VPD'), ColPOSIXTime = "TIMESTAMP")   
EddyProc.C$sSetLocationInfo(LatDeg = 47.210227, LongDeg = 8.410645, TimeZoneHour = 1)  # CH-CHA coordinates
str(EddyProc.C)
head(EddyProc.C$sDATA)
head(EddyProc.C$sTEMP)


# Gap-fill fluxes
# ===============
EddyProc.C$sMDSGapFill('NEE_CUT_50', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('LE', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('H', FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Tair', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Rg', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('VPD', FillAll = FALSE, isVerbose = TRUE)


# Calculate ET from LE
# ====================
EddyProc.C$sTEMP$ET_f <- fCalcETfromLE(EddyProc.C$sTEMP$LE_f, EddyProc.C$sDATA$Tair)
summary(EddyProc.C$sTEMP)


# PARTITIONING
# ============
EddyProc.C$sMRFluxPartition(FluxVar = 'NEE_CUT_50_f', QFFluxVar = 'NEE_CUT_50_fqc', suffix = 'CUT_50')
EddyProc.C$sGLFluxPartition(NEEVar = 'NEE_CUT_50_f', suffix = 'CUT_50')


# COLLECT DATA AND EXPORT
# =======================
cat("Export data to standard data frame ...")
FilledEddyData.F <- EddyProc.C$sExportResults()
FilledEddyData.F$TIMESTAMP          <-EddyData.F$TIMESTAMP
write.csv(FilledEddyData.F, file = paste("L:/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/33_FLUXES_L4_REddyProc_GapFilling_Partitioning_IRGA/33.2_FLUXES_L4_MDSgapfilledPart_NEECUT50_LE_H_", run_id,".csv",sep="")) 


# PLOT: FINGERPRINTS
# ==================
# Save fingerprint plots as PDF
outdir = "L:/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/33_FLUXES_L4_REddyProc_GapFilling_Partitioning_IRGA/plots/"
EddyProc.C$sPlotFingerprint('NEE_CUT_50_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('GPP_CUT_50_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('GPP_DT_CUT_50', Dir = outdir)
EddyProc.C$sPlotFingerprint('Reco_CUT_50', Dir = outdir)
EddyProc.C$sPlotFingerprint('Reco_DT_CUT_50', Dir = outdir)
EddyProc.C$sPlotFingerprint('LE_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('ET_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('Tair_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('Rg_f', Dir = outdir)
EddyProc.C$sPlotFingerprint('VPD_f', Dir = outdir)


# PLOT PER YEAR
# =============

FilledEddyData.F = FilledEddyData.F %>% mutate(
  Date = as.Date(TIMESTAMP,'%Y-%m-%d'), 
  Time = as.character(format(TIMESTAMP, '%H:%M')),
  Year = as.numeric(format(TIMESTAMP,'%Y')))

# PLOT: NEE, GPP, RECO
# ====================
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
  
  ggsave(paste(outdir, as.character(Yr),"_CH-CHA_CUT50_NEE_GPP_RECO_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
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
  
  ggsave(paste(outdir, as.character(Yr),"_CH-CHA_NEE_LE_ET_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
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
  
  ggsave(paste(outdir, as.character(Yr),"_CH-CHA_SWIN_TA_VPD_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm')
  
  print(summary(Year_Filled_Eddy_Data$TIMESTAMP))
  print(Yr)
}


# PLOT: DAILY AGGREGATION
# =======================

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

ggsave(paste(outdir, "CH-CHA_DOY_Daily.png"), gr ,height = 300, width =600, units = 'mm')


#############------------------------------ End of Script --------------------------------------------------------------------##################
### Thank you for your patience.

