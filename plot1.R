library(dplyr)

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
data <- select(data, Date, Global_active_power)
d1 <- subset(data, Date == '2007-02-01')
d2 <- subset(data, Date == '2007-02-02')
data <- as.data.frame(rbind(d1,d2))
rm(d1)
rm(d2)
data <- mutate(data, GAP = as.numeric(as.character(Global_active_power)))
#make the plot
hist(data$GAP, xlab = 'Global Active Power (kilowatts)', main ='Global Active Power', col = 'red')
#copy to png
dev.copy(png, file = 'plot1.png', height = 480, width = 480)
dev.off()