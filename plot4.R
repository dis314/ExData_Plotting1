library(data.table)

# reading only lines for 1 and 2 Feb 2007
hpc <- fread("household_power_consumption.txt", na.strings = "?", skip = "1/2/2007", nrows = 2880, 
             colClasses = c("POSIXlt", "character", rep("numeric", 7))) 

# setting proper variable names
names(hpc) <- c("Date", "Time", "GlobalActivePower", 
                "GlobalReactivePower", "Voltage", "GlobalIntensity",
                "SubMetering1", "SubMetering2", "SubMetering3")

# adding Timeline variable
hpc$Date <- as.Date(as.character(hpc$Date), format = "%d/%m/%Y")
hpc$Time <- as.ITime(as.character(hpc$Time), format = "%H:%M:%S")
hpc <- within(hpc, { Timeline = format(as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S") })

# opening png graphic device
png("plot4.png")

# setting a form of the plot and other necessary parameters for making 4 plots
par(mfrow = c(2, 2), bg = "transparent", cex = 0.75, mar = c(6, 4, 2, 1), oma = c(2, 2, 4, 2))

# drawing plots
with(hpc, { 
        plot(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
             GlobalActivePower, type = "l", xlab = "", ylab = "Global Active Power")
        plot(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
             Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
        plot(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
             SubMetering1, type = "l", xlab = "", ylab = "Energy sub metering")
        lines(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
              SubMetering2, col = "red")
        lines(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
              SubMetering3, col = "blue")
        legend("topright", lty = 1, bty = "n", col = c("black", "red", "blue"), 
               legend = c("SubMetering1", "SubMetering2", "SubMetering3"))
        plot(strptime(Timeline, format = "%d/%m/%Y %H:%M:%S"), 
             GlobalReactivePower, type = "l", xlab = "datetime", ylab = "Global Reactive Power")
        
})

# closing graphic device
dev.off()
