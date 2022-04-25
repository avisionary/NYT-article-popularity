# script used to merge all of the three individual csv files generated

avi = read.csv('../data/avi_munging.csv')
oli = read.csv('../data/oli_munging.csv')
vin = read.csv('../data/number_keywords_column.csv')


#default FULLDF to Avi's
fullDF = avi

#add Oli features
fullDF$is_racial = oli$is_racial
fullDF$is_political = oli$is_political

#add Vin features csv
fullDF$num_keywords = vin$Number_keywords


#Write fullDF to new CSV file
write.csv(fullDF, file = '../data/fullDF.csv', row.names = F)
