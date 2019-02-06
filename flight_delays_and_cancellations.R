
#  Working directory
getwd()
setwd("/Users/yossigausman/Desktop/DSA/RDA/Working Directory")

# Installed packages
install.packages('dplyr')
install.packages('plotly')
install.packages('sqldf')

# Used libraries
library('dplyr')
library('plotly')
library('sqldf')

#--- 1.Import of the files flights.csv, airlines.csv

flights_raw <- read.csv("flights.csv", header=TRUE, na.strings=c("","NA"))
airlines_raw <- read.csv("airlines.csv", header=TRUE, na.strings=c("","NA"))

# Just looking at the data.
head(flights_raw)
head(airlines_raw)

tail(flights_raw)
tail(airlines_raw)

# Joining tables: flights and airlines.
flights <- sqldf("SELECT * FROM flights_raw JOIN airlines_raw ON 
                  flights_raw.AIRLINE = airlines_raw.IATA_CODE")
names(flights)
names(flights)[33] <- "AIRLINE_NAME"
write.csv(names(flights), "Variables.csv")

#--- 2.Data cleaning----------------------------------------------------------------------------------------

# Missing Data
missing_data <- sapply(flights, function(x) sum(is.na(x)))

# SCHEDULED_TIME != NA, AIR_TIME != NA
flights.clean <- subset(flights, !(is.na(flights$AIR_TIME)))
flights.clean <- subset(flights.clean, !(is.na(flights.clean$SCHEDULED_TIME)))

# Making sure the data is clean
missing_data <- sapply(flights.clean, function(x) sum(is.na(x)))

#---3.Market Share----------------------------------------------------------------------------------------

MarketShare <- summarise(group_by(flights.clean, AIRLINE_NAME), Count=n(),
                         mean_ARRIVAL_DELAY <- mean(ARRIVAL_DELAY, na.rm = TRUE),
                         mean_DEPARTURE_DELAY <- mean(DEPARTURE_DELAY, na.rm = TRUE))

arrange(MarketShare,desc(Count))
write.csv(MarketShare, "MarketShare.csv")

plot_ly(MarketShare, labels = ~AIRLINE_NAME, values = ~Count, type = 'pie',
        textposition = 'inside', textinfo = 'label+percent',
        insidetextfont = list(color = '#FFFFFF'), hoverinfo = 'text',
        marker = list(line = list(color = '#FFFFFF', width = 1)),
        showlegend = FALSE)

#--- 4.Cancelled flights--------------------------------------------------------------------------------

# Cancelations Percent
cancelled_flights <- subset(flights, flights$CANCELLED==1)
cancelled_flights_percent <- nrow(cancelled_flights)/nrow(flights.clean)*100

# Cancelation reasons
cancellation_reason <- summary(factor(cancelled_flights$CANCELLATION_REASON))

# Airline related cancellations
cancellation_reason[1]/sum(cancellation_reason)*100 

# Weather related cancellations
cancellation_reason[2]/sum(cancellation_reason)*100 

# Air system related cancellations
cancellation_reason[3]/sum(cancellation_reason)*100

# Security related cancellations
cancellation_reason[4]/sum(cancellation_reason)*100

# Airline cancellations compared to all cancelled flights made by all airlines
temp <- subset(cancelled_flights, factor(cancelled_flights$CANCELLATION_REASON)=='A')

airline_cancellation_freq <- summary(factor(temp$AIRLINE_NAME))
airline_all_cancellation_rate <- sort(round(airline_cancellation_freq / nrow(temp)*100, 2), decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(airline_all_cancellation_rate, las = 2, col = cols, ylab = "Cancellation Rate [%]",
        main="Airline Cancellation Rate (Cancelled Flights)", cex.names = 1.1, ylim=c(0,25))

# Airline cancellations compared to all flights made by the airline
airline_cancellation_freq <- summary(factor(temp$AIRLINE_NAME))
all_flight_freq <- summary(factor(flights.clean$AIRLINE_NAME))
airline_cancellation_rate <- sort(airline_cancellation_freq / all_flight_freq*100, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(airline_cancellation_rate, las = 2, col = cols, ylab = "Cancellation Rate [%]",
        main="Airline Cancellation Rate (Airline Flights)", cex.names = 1.1, ylim=c(0,1.0))

airline_cancellation_score <- airline_cancellation_freq / all_flight_freq

#--- 5.Departure Delay Analysis by Airline-----------------------------------------------------------------

late_departure <- subset(flights.clean, flights.clean$DEPARTURE_DELAY>0)
ontime_departure <- subset(flights.clean, flights.clean$DEPARTURE_DELAY<=0)
early_departure <- subset(flights.clean, flights.clean$DEPARTURE_DELAY <= -5)

late_departure_percent <- nrow(late_departure)/nrow(flights.clean)*100
ontime_departure_percent <- nrow(ontime_departure)/nrow(flights.clean)*100
early_departure_percent <- nrow(early_departure)/nrow(flights.clean)*100

# Departures delayed due to airline compared to all delayed flights
temp <- subset(late_departure, !is.na(late_departure$AIRLINE_DELAY))

departure_delay_freq <- summary(factor(temp$AIRLINE_NAME))
airline_departure_delay <- sort(departure_delay_freq/nrow(temp)*100, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(airline_departure_delay, las = 2, col = cols, ylab = "% Delayed Flights", 
        main="Departure Delay - Delayed Flights", cex.names = 1.1, ylim=c(0,25))

# Departures delayed due to airline compared to all flights made by the airline
departure_delay_freq <- summary(factor(temp$AIRLINE_NAME))
all_flights_freq <- summary(factor(flights.clean$AIRLINE_NAME)) 

departure_delay_rate <- sort(departure_delay_freq / all_flights_freq*100, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(departure_delay_rate, las = 2, col = cols, ylab = "% Delayed Flights", 
        main="Departure Delay - Airline Flights", cex.names = 1.1, ylim=c(0,30))

departure_delay_score <- departure_delay_freq / all_flights_freq

# Average departure delays times
departure_delay_time <- aggregate(temp$DEPARTURE_DELAY, by=list(Airline=temp$AIRLINE_NAME), FUN=sum)
departure_delay_freq <- summary(factor(temp$AIRLINE_NAME))

avg_dep_delay_times <- sort(departure_delay_time$x / departure_delay_freq, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(avg_dep_delay_times, las = 2, col = cols, ylab = "Time [min]", 
        main="Average Departure Delay Time", cex.names = 1.1, ylim=c(0,80))

#--- 6.Arrival delay Analysis by Airline-------------------------------------------------------------------------
late_arrival <- subset(flights.clean, flights.clean$ARRIVAL_DELAY > 0)
ontime_arrival <- subset(flights.clean, flights.clean$ARRIVAL_DELAY <= 0)
early_arrival <- subset(flights.clean, flights.clean$ARRIVAL_DELAY <= -5)

late_arrival_percent <- nrow(late_arrival)/nrow(flights.clean)*100
ontime_arrival_percent <- nrow(ontime_arrival)/nrow(flights.clean)*100
early_arrival_percent <- nrow(early_arrival)/nrow(flights.clean)*100

# Arrivals delayed due to airline compared to all delayed flights
temp <- subset(late_arrival, !is.na(late_arrival$AIRLINE_DELAY))

arrival_delay <- sort(summary(factor(temp$AIRLINE_NAME))/nrow(temp)*100, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(arrival_delay, las = 2, col = cols, ylab = "% Delayed Flights", 
        main="Arrival Delay - Delayed Flights", cex.names = 1.1, ylim=c(0,25))

# Arrivals delayed due to Airline compared to all flights made by the airline
arrival_delay_freq <- summary(factor(temp$AIRLINE_NAME))
all_flights_freq <- summary(factor(flights.clean$AIRLINE_NAME)) 

arrival_delay_rate <- sort(arrival_delay_freq / all_flights_freq*100, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(arrival_delay_rate, las = 2, col = cols, ylab = "% Delayed Flights", 
        main="Arrival Delay - All Flights", cex.names = 1.1, ylim=c(0,30))

arrival_delay_score <- arrival_delay_freq / all_flights_freq

# Average Arrival Delays Times
arrival_delay_time <- aggregate(temp$ARRIVAL_DELAY, by=list(Airline=temp$AIRLINE_NAME), FUN=sum)
arrival_delay_freq <- summary(factor(temp$AIRLINE_NAME))

avg_arrival_delay_times <- sort(arrival_delay_time$x / arrival_delay_freq, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14)
par(mar=c(13.5,4.5,3,3))
barplot(avg_arrival_delay_times, las = 2, col = cols, ylab = "Time [min]", 
        main="Average Arrival Delay Times", cex.names = 1.1, ylim=c(0,80))

#--- 7.Airline Overall score 
airline_score <- sort(airline_cancellation_score + departure_delay_score +
                 arrival_delay_score, decreasing = TRUE)

cols <- colorRampPalette(c('blue','green','red','yellow'))(14);
par(mar=c(13.5,4.5,3,3))
barplot(airline_score, las = 2, col = cols, ylab = "Score", main="Airline Overall Score", 
                      cex.names = 1.1, ylim=c(0,0.7))
