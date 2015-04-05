# Downloading and unzipping initial archive
tempfile <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, tempfile, method="curl")
unzip(tempfile)  # unzip our archive
unlink(tempfile) #delete temporary file


#Opening feature file and setting its column names
PowerConsumption <- read.table("household_power_consumption.txt", header=TRUE, sep= ";", na.strings="?")
#Adding Date+Time column in POSIXlt format
library(dplyr)
PowerConsumption <- mutate(PowerConsumption, DateTime=paste(PowerConsumption$Date, PowerConsumption$Time))
PowerConsumption$DateTime <- strptime(PowerConsumption$DateTime, format="%d/%m/%Y %H:%M:%S")
PowerConsumption$Date <- as.Date(PowerConsumption$DateTime, "%d/%b/%Y")

#Making a working subset with dates[2007-02-01; 2007-02-02]
FilteredDates <- subset(PowerConsumption, as.POSIXct(PowerConsumption$DateTime)>=as.POSIXct("2007-02-01 00:00:00") & as.POSIXct(PowerConsumption$DateTime)<as.POSIXct("2007-02-03 00:00:00"))

# Converting other columns to numeric format
for (i in 3:9) FilteredDates[,i] <- as.numeric(as.character(FilteredDates[,i]))

#Drawing plot 4
par(mfrow=c(2,2), bg = "transparent", mar=c(5,4,3,2), oma=c(3,0,2,2),cex=0.6)
#par(mfrow=c(2,2), bg = "transparent", mar=c(8,4,5,4), oma=c(0,0,0,0), cex=0.8)
#1
with(FilteredDates, plot(DateTime, Global_active_power, xlab=NA, ylab="Global Active Power",lty=1, lwd=1, pch=".", type="n"))
with(FilteredDates, lines(DateTime, Global_active_power, xlab=NA, ylab="Global Active Power",lty=1, lwd=1, pch="."))
#2
with(FilteredDates, plot(DateTime, Voltage, xlab="datetime", ylab="Voltage",lty=1, lwd=1, pch=".", type="n"))
with(FilteredDates, lines(DateTime, Voltage, xlab="datetime", ylab="Voltage",lty=1, lwd=1, pch="."))
#3
with(FilteredDates, plot(DateTime, Sub_metering_1, xlab=NA, ylab="Energy sub metering",lty=1, lwd=1, pch=".", type="n"))
with(FilteredDates, lines(DateTime, Sub_metering_1,lty=1, lwd=1, pch="."))
with(FilteredDates, lines(DateTime, Sub_metering_2,lty=1, lwd=1, pch=".", col="red"))
with(FilteredDates, lines(DateTime, Sub_metering_3,lty=1, lwd=1, pch=".", col="blue"))
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),box.lwd=0,cex=0.7, lty=1, col=c("black","red","blue"))
#4
with(FilteredDates, plot(DateTime, Global_reactive_power, xlab="datetime", ylab="Global_reactive_power",lty=1, lwd=1, pch=".", type="n"))
with(FilteredDates, lines(DateTime, Global_reactive_power, xlab="datetime", ylab="Global_reactive_power",lty=1, lwd=1, pch="."))
#write to file
dev.copy(png, file="plot4.png", width=480,height=480, type="quartz")
dev.off()