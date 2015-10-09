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
png("plot1.png")

# setting plot background color
par(bg = "transparent")

# drawing histogram
hist(hpc$GlobalActivePower, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# closing graphic device
dev.off()

