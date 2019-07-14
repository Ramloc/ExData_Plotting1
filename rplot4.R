#start with loading the right packages

library(dplyr)
library(ggplot2)
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
data <- select(data, Date, Global_active_power, Time, Voltage,Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_reactive_power)

#now to select the dates we need
d1 <- subset(data, Date == '2007-02-01')
d2 <- subset(data, Date == '2007-02-02')
data <- as.data.frame(rbind(d1,d2))
rm(d1)
rm(d2)
#now to transform the data properly so that we get proper numeric values
data <-mutate(data, Datetime = as.POSIXct(strptime(paste(data$Date, data$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")))
data <- mutate(data, GAP = as.numeric(as.character(Global_active_power)))
data <- mutate(data, Voltage = as.numeric(as.character(Voltage)))

#now to make the plot by opening a file and writing directly into it
png("plot4.png", width = 480, height = 480)
par(mfrow= c(2,2))
plot(data$Datetime, data$GAP, type = 'l', ylab ='Global Active Power', xlab ='')
plot(data$Datetime, data$Voltage, type = 'l', ylab ='Voltage', xlab ='datetime')
data <-mutate(data, Sub_metering_1 = as.numeric(as.character(Sub_metering_1)))
data <-mutate(data, Sub_metering_2 = as.numeric(as.character(Sub_metering_2)))
data <-mutate(data, Sub_metering_3 = as.numeric(as.character(Sub_metering_3)))
plot(data$Datetime, data$Sub_metering_1, type = 'n', ylab = 'Energy sub metering', xlab ='')
points(data$Datetime, data$Sub_metering_1, type = 'l')
points(data$Datetime, data$Sub_metering_2, type = 'l', col = 'red')
points(data$Datetime, data$Sub_metering_3, type = 'l', col = 'blue')
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1, bty ='n')
data <- mutate(data, Global_reactive_power = as.numeric(as.character(Global_reactive_power)))
plot(data$Datetime, data$Global_reactive_power, type = 'l', ylab ='Global_reactive_power', xlab ='datetime')
dev.off()

#end