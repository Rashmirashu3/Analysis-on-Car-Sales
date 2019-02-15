#Use library
library(RODBC)

#List all your ODBC connections
odbcDataSources(type = c("all", "user", "system"))

#Create connection - Note if you leave uid and pwd blank it works with your existing Windows credentials
Local <- odbcConnect("Rashmi", uid = "", pwd = "")

#Query a database (select statement)
Carsales<-  sqlQuery(Local, "SELECT * FROM UC.dbo.CarSales")

#View data
head(Carsales)


#Check the structure of the data
class(Carsales)

#Quick summary to describe the data
summary(Carsales)

#Data distribution using box plots
par(mfrow=c(1,4))
boxplot(Carsales$Year,main='Year')
boxplot(Carsales$Month,main='Month')
boxplot(Carsales$Quantity, main='Quantity')
boxplot(Carsales$PercentShare,main='PercentShare')

#Data distribution using histogram
hist(Carsales$Quantity)
hist(Carsales$PercentShare)

#Data distribution using plots
plot(Carsales$Year,Carsales$Quantity)
plot(Carsales$Month,Carsales$Quantity)
