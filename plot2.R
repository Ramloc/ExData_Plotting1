library(dplyr)
library(lubridate)

#now to check if we have the files, if not we will download them
URL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
zipfile <-"exdata_data_household_power_consumption.zip"
if (!file.exists(zipfile)) {
  download.file(URL, zipfile, mode = "wb")}
datafile <- "household_power_consumption"
if (!file.exists(datafile)) {
  unzip(zipfile)}

#now to read the data into R and select the columns we need

data <- read.table('household_power_consumption.txt', sep = ';', header = TRUE)
data <-mutate(data, Date = as.Date(Date, format = '%d/%m/%Y'))
data <- select(data, Date, Global_active_power, Time)
d1 <- subset(data, Date == '2007-02-01')
d2 <- subset(data, Date == '2007-02-02')
data <- as.data.frame(rbind(d1,d2))
rm(d1)
rm(d2)
data <-mutate(data, Datetime = as.POSIXct(strptime(paste(data$Date, data$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")))
data <- mutate(data, GAP = as.numeric(Global_active_power) /1000)

#make the plot and copy to png
plot(data$Datetime, data$GAP, type = 'l', ylab ='Global Active Power (kilowatts)', xlab ='')
# 
# 
dev.copy(png, file = 'plot2.png', width = 480, height = 480)
dev.off()