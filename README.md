# Flight Delays and Cancellations

## Introduction

There is a good chance that if you try to inquire about the reason of your flight delay or cancellation, you&#39;ll hear the mystical expression &quot;operational reasons&quot;.  Flight Delays and Cancellations dataset was used to find and define these &quot;operational reasons&quot;.

## Description of the dataset

Flight Delays and Cancellations dataset was downloaded from [www.kaggle.com](http://www.kaggle.com). The data was collected from 14 USA based airlines that traveled between 322 airports in 2015. After loading and joining the source files (flights.csv, airlines.csv) the final dataset resulted in 33 variables and 5,819,079 observations of witch 105,000 contained missing data.

List of Variables:

| YEAR | ORIGIN\_AIRPORT | SCHEDULED\_TIME | ARRIVAL\_TIME | AIRLINE\_DELAY |
| --- | --- | --- | --- | --- |
| MONTH | DESTINATION\_AIRPORT | ELAPSED\_TIME | ARRIVAL\_DELAY | LATE\_AIRCRAFT\_DELAY |
| DAY | SCHEDULED\_DEPARTURE | AIR\_TIME | DIVERTED | WEATHER\_DELAY |
| DAY\_OF\_WEEK | DEPARTURE\_TIME | DISTANCE | CANCELLED | IATA\_CODE |
| AIRLINE | DEPARTURE\_DELAY | WHEELS\_ON | CANCELLATION\_REASON | AIRLINE\_NAME |
| FLIGHT\_NUMBER | TAXI\_OUT | TAXI\_IN | AIR\_SYSTEM\_DELAY |   |
| TAIL\_NUMBER | WHEELS\_OFF | SCHEDULED\_ARRIVAL | SECURITY\_DELAY |   |

## Description of Analysis

The main goals of the analysis were to determine the reasons for flight delays and cancellations and to rank the airlines companies based on their performance. To that matter, the analysis focused on the next parameters:

Cancellation reasons: Summary of all cancelled flights grouped by for 4 main reasons for cancellation (Airline, Weather, Security, and National Air System).

Canceled Flights: Flights canceled by the airline compered to flights made by the airline/all airlines.

Departure and Arrival Delays: Airline delayed flights compared to flights made by the airline/all airlines.

Duration of the Delays: Average departure and arrival delay times for each airline company.

Final Score and Ranking: For each parameter in the analysis a separate score was calculated and summed up to a final total score.

## Conclusions

- The weather is the major contributor (54%) to flight cancellations.
- Cancellation rate of all flights (1.6%) was found to be relatively low.
- Average departure and arrival delays were scattered around 1 hour.
- The best and the worst airline companies were found to hold less than 4% of the market share, with the major companies lying in between.
