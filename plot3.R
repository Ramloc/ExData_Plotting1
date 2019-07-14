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
data <- select(data, Date, Sub_metering_1, Sub_metering_2, Sub_metering_3, Time)
d1 <- subset(data, Date == '2007-02-01')
d2 <- subset(data, Date == '2007-02-02')
data <- as.data.frame(rbind(d1,d2))
rm(d1)
rm(d2)
#transform the data into the required formats
data <-mutate(data, Datetime = as.POSIXct(strptime(paste(data$Date, data$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")))
data <-mutate(data, Sub_metering_1 = as.numeric(as.character(Sub_metering_1)))
data <-mutate(data, Sub_metering_2 = as.numeric(as.character(Sub_metering_2)))
data <-mutate(data, Sub_metering_3 = as.numeric(as.character(Sub_metering_3)))
#make the plot and copy to png
plot(data$Datetime, data$Sub_metering_1, type = 'n', ylab = 'Energy sub metering', xlab ='')
points(data$Datetime, data$Sub_metering_1, type = 'l')
points(data$Datetime, data$Sub_metering_2, type = 'l', col = 'red')
points(data$Datetime, data$Sub_metering_3, type = 'l', col = 'blue')
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1)

dev.copy(png, file = 'plot3.png', width = 480, height = 480)
dev.off()