#!/usr/bin/env Rscript

#Load library
require(dplyr)

# Download dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datafile<- "./data/household_power_consumption.zip"
download.file(fileUrl,destfile=datafile,method="curl")

# Uncompress the zip file
unzip(zipfile=datafile,exdir="./data")

# Read the file
path_rf <- file.path("./data")
data  <- read.table(file.path(path_rf, "household_power_consumption.txt" ),header = TRUE, sep=';', na.strings='?')

# Change the date format from string to date.
data$Date<-as.Date(data$Date, format="%d/%m/%Y")

# Filter the records by dates
data<-filter(data, Date>= "2007-02-01" & Date<="2007-02-02")

# Add the new Datetime column
data<-mutate(data, Datetime=as.POSIXct(paste(as.Date(data$Date),data$Time)))

# Plot 3 and save to png file
png(filename = "plot3.png", width = 480, height = 480, units = "px")

with(data, {
  plot(Sub_metering_1~Datetime, type="l",
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()



