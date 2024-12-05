# CH-CHA
# Gap-filling fluxes


# SETTINGS
# ========
SITE <- "CH-CHA"
SITE_LAT <- 47.210227
SITE_LON <- 8.410645
INPUT_FLUX <- "NEE_L3.1_L3.3_CUT_84_QCF"
OUTPUT_FLUX <- "NEE_CUT_84"
SUFFIX <- "CUT_84"
FROM <- "2005-01-01 00:30:00"
TO <- "2024-01-01 00:00:00"
INPUT_FILE_FLUX_METEO <- "F:/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/32_FLUXES_L1_FluxProcessingChain_IRGA/32.9_FluxProcessingChain_L3.3_subset-forREddyProcGapFilling.csv"
OUTDIR <- "F:/Sync/luhk_work/20 - CODING/29 - WORKBENCH/dataset_cha_fp2024_2005-2023/notebooks/33_FLUXES_L4_REddyProc_MDSGapFilling_IRGA/"
OUTDIR_PLOTS <- paste(OUTDIR, "plots_", OUTPUT_FLUX, "/", sep="")

# Auto-settings
filledfluxvar <- paste(OUTPUT_FLUX, "f", sep="_")
filledflagvar <- paste(OUTPUT_FLUX, "fqc", sep="_")


# IMPORTS
# =======
library(ggplot2)
library(REddyProc)
library(caTools)
library(dplyr)
library(viridis)
library(readr)
library(segmented)


# RUN ID
# ======
run_id <- format(Sys.time(), "%Y%m%d%H%M%S",tz="GMT")   ## To give unique ID to saved output files


# DATA FROM FILE
# ==============
output_path <- getwd()
Sys.setenv(TZ = "GMT")
filedata <- read.csv(INPUT_FILE_FLUX_METEO, header = 1)
filedata$TIMESTAMP <- as.POSIXct(filedata$TIMESTAMP_END, format="%Y-%m-%d %H:%M:%S")
summary(filedata)
head(filedata)
colnames(filedata)


# DATA COLUMNS
# ============
EddyData.F <- filedata[FALSE]
EddyData.F$TIMESTAMP <- as.POSIXct(filedata$TIMESTAMP, format = '%m/%d/%Y %H:%M', tz = Sys.timezone())

# Vars for gap-filling
EddyData.F[, OUTPUT_FLUX] <- as.numeric(as.character(filedata[, INPUT_FLUX]))
EddyData.F$Rg <- as.numeric(as.character(filedata$SW_IN_T1_2_1))
EddyData.F$Tair <- as.numeric(as.character(filedata$TA_T1_2_1))
EddyData.F$VPD <- as.numeric(as.character(filedata$VPD_T1_2_1))
EddyData.F$VPD[EddyData.F$VPD < 0] <- NA  # To remove -9999 missing values
EddyData.F$VPD <- EddyData.F$VPD * 10  # Convert from kPa to hPa
summary(EddyData.F$VPD)

# Restrict time range
EddyData.F <- subset (EddyData.F, TIMESTAMP >= as.POSIXct(FROM))  # Date with first fluxes
EddyData.F <- subset (EddyData.F, TIMESTAMP <= as.POSIXct(TO))
summary(EddyData.F)


# Initialize R5 reference class
# ============================
EddyProc.C <-sEddyProc$new(SITE,  EddyData.F,
                           c(OUTPUT_FLUX,'Rg','Tair','VPD'), ColPOSIXTime = "TIMESTAMP")   
EddyProc.C$sSetLocationInfo(LatDeg = SITE_LAT, LongDeg = SITE_LON, TimeZoneHour = 1)  # CH-CHA coordinates
str(EddyProc.C)
head(EddyProc.C$sDATA)
head(EddyProc.C$sTEMP)


# MDS GAP-FILLING
# ===============
EddyProc.C$sMDSGapFill(OUTPUT_FLUX, FillAll = TRUE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Tair', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('Rg', FillAll = FALSE, isVerbose = TRUE)
EddyProc.C$sMDSGapFill('VPD', FillAll = FALSE, isVerbose = TRUE)


# # Calculate ET from LE
# # ====================
# EddyProc.C$sTEMP$ET_f <- fCalcETfromLE(EddyProc.C$sTEMP$LE_f, EddyProc.C$sDATA$Tair)
# summary(EddyProc.C$sTEMP)


# # PARTITIONING
# # ============
# EddyProc.C$sMRFluxPartition(FluxVar = filledfluxvar, QFFluxVar = filledflagvar, suffix = SUFFIX)
# EddyProc.C$sGLFluxPartition(NEEVar = filledfluxvar, suffix = SUFFIX)


# COLLECT DATA AND EXPORT
# =======================
cat("Export data to standard data frame ...")
FilledEddyData.F <- EddyProc.C$sExportResults()
FilledEddyData.F$TIMESTAMP          <-EddyData.F$TIMESTAMP
write.csv(FilledEddyData.F, file = paste(OUTDIR, "33.06_FLUXES_L4.1_MDSgapfilled_", OUTPUT_FLUX, "_", run_id,".csv",sep="")) 



# PLOT PER YEAR
# =============

FilledEddyData.F = FilledEddyData.F %>% mutate(
  Date = as.Date(TIMESTAMP,'%Y-%m-%d'), 
  Time = as.character(format(TIMESTAMP, '%H:%M')),
  Year = as.numeric(format(TIMESTAMP,'%Y')))



# PLOT: FLUX, SW_IN, TA, VPD
# ==========================
for (Yr in c(2005:2023))
{
  Year_Filled_Eddy_Data = FilledEddyData.F %>% filter(Year == Yr)
  summary(Year_Filled_Eddy_Data$TIMESTAMP)
  
  a = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Year_Filled_Eddy_Data[, filledfluxvar])) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle(filledfluxvar) + theme(axis.text.x=element_blank())
  
  b = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Rg_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('SW_IN') + theme(axis.text.x=element_blank())
  
  c = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = Tair_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('TA') + theme(axis.text.x=element_blank())
  
  d = ggplot(Year_Filled_Eddy_Data, aes(x = Time, y = Date, fill = VPD_f)) + geom_tile() + scale_fill_viridis(option = "D") +
    ggtitle('VPD') + theme(axis.text.x=element_blank())
  
  gr = gridExtra::arrangeGrob(a,b,c,d, ncol = 4)
  
  ggsave(paste(OUTDIR_PLOTS, as.character(Yr),"_",SITE,"_",OUTPUT_FLUX,"_","SWIN_TA_VPD","_", run_id,".png",sep=""), gr ,height = 200, width = 450, units = 'mm', create.dir = TRUE)
  
  print(summary(Year_Filled_Eddy_Data$TIMESTAMP))
  print(Yr)
}

 
#############------------------------------ End of Script --------------------------------------------------------------------##################
### Thank you for your patience.

