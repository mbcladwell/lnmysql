rm(list=ls(all=TRUE))
library(ggplot2)


file.name <-"~/projects/lnmysql//Rutilities/layouts/plate_layouts_for_import.txt" 
d <- read.table( file = file.name,   sep = "\t", header=TRUE)



dest.name <-"~/projects/lnmysql//Rutilities/layouts/plate_layouts_for_import_mysql.sql"
file.remove(dest.name)

cat("INSERT INTO plate_layout (plate_layout_name_id, well_by_col, well_type_id, replicates, target) VALUES ", file=dest.name, append=TRUE)

for (i in 1:nrow(d)){
    if( i == nrow(d)){
        line <- paste("(", d[i,"plate_layout_name_id"],", ", d[i,"well_by_col"],", ", d[i,"well_type_id"],", ", d[i,"replicates"],", ", d[i,"target"], ")", sep="")        
    }else{
        line <- paste("(", d[i,"plate_layout_name_id"],", ", d[i,"well_by_col"],", ", d[i,"well_type_id"],", ", d[i,"replicates"],", ", d[i,"target"],"),", sep="")        
    }   
    cat(line, file=dest.name, append=TRUE)
}




## for 96 well plate 4 controls

id <- 1
well <- 1:96
type <- c(rep(1,92), c(2,2,3,4))
reps <- 1
target <- 1
    
LYT.1 <- data.frame(cbind(id, well, type, reps, target))

## 4 controls
##384 sample single

##1S4T
id <- 2
well <- 1:384
type <- c(rep(1,360), c(2,2,2,2,3,3,4,4), rep(1,8), c(2,2,2,2,3,3,4,4)  )
reps <- rep(c(rep(c(1,3),8), rep(c(2,4),8)),12) 
target <- 1
LYT.2 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 3
well <- 1:384
type <- c(rep(1,360), c(2,2,2,2,3,3,4,4), rep(1,8), c(2,2,2,2,3,3,4,4)  )
reps <- c(1,2) 
target <-  c(rep(1,16), rep(2,16))  
LYT.3 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 4
well <- 1:384
type <- c(rep(1,360), c(2,2,2,2,3,3,4,4), rep(1,8), c(2,2,2,2,3,3,4,4)  )
reps <- c(1,2) 
target <- 1  
LYT.4 <- data.frame(cbind(id, well, type, reps, target))



##4S1T
id <- 5
well <- 1:384
type <- c(rep(1,360), c(2,2,2,2,3,3,4,4), rep(1,8), c(2,2,2,2,3,3,4,4)  )
reps <- 1 
target <- c(rep(c(1,2),8), rep(c(3,4),8) )
LYT.5 <- data.frame(cbind(id, well, type, reps, target))



##4S2T
id <- 6
well <- 1:384
type <- c(rep(1,360), c(2,2,2,2,3,3,4,4), rep(1,8), c(2,2,2,2,3,3,4,4)  )
reps <- 1
target <- c(rep(1,16), rep(2,16))
LYT.6 <- data.frame(cbind(id, well, type, reps, target))


###############################################################




##############
## 8 controls
#############

id <- 7
well <- 1:96
type <- c(rep(1,88), c(2,2,2,2,3,3,4,4))
reps <- 1
target <- 1  
LYT.7 <- data.frame(cbind(id, well, type, reps, target))


##384 single

##1S4T
id <- 8
well <- 1:384
type <- c(rep(1,352), rep(c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), 2)  )
reps <- rep(c(rep(c(1,3),8), rep(c(2,4),8)),12) 
target <- 1
LYT.8 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 9
well <- 1:384
type <- c(rep(1,352), rep(c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), 2)  )
reps <- c(1,2) 
target <-  c(rep(1,16), rep(2,16))  
LYT.9 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 10
well <- 1:384
type <- c(rep(1,352), rep(c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), 2)  )
reps <- c(1,2) 
target <- 1  
LYT.10 <- data.frame(cbind(id, well, type, reps, target))



##4S1T
id <- 11
well <- 1:384
type <- c(rep(1,352), rep(c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), 2)  )
reps <- 1 
target <- c(rep(c(1,2),8), rep(c(3,4),8) )
LYT.11 <- data.frame(cbind(id, well, type, reps, target))



##4S2T
id <- 12
well <- 1:384
type <- c(rep(1,352), rep(c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), 2)  )
reps <- 1
target <- c(rep(1,16), rep(2,16))
LYT.12 <- data.frame(cbind(id, well, type, reps, target))



#####################
## 384 well source 
####################

###8 controls

id <- 13
well <- 1:384
type <- c(rep(1,376), c(2,2,2,2,3,3,4,4)  )
reps <- 1
target <- 1
LYT.13 <- data.frame(cbind(id, well, type, reps, target))

###1536 destinations

##1S4T
id <- 14
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- c(rep(c(1,3),16),rep(c(2,4),16)) 
target <- 1
LYT.14 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 15
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- rep(c(1,2),32) 
target <- c(rep(1,32), rep(2,32))    
LYT.15 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 16
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- rep(c(1,2),32) 
target <- 1
LYT.16 <- data.frame(cbind(id, well, type, reps, target))


##4S1T
id <- 17
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- 1
target <- c(rep(c(1,2),16), rep(c(3,4),16) )
LYT.17 <- data.frame(cbind(id, well, type, reps, target))

##4S2T
id <- 18
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- 1
target <- c(rep(1,32), rep(2,32))    
LYT.18 <- data.frame(cbind(id, well, type, reps, target))


##############################################################
###16 controls   384 source

id <- 19
well <- 1:384
type <- c(rep(1,368), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )        
reps <- 1
target <- 1
LYT.19 <- data.frame(cbind(id, well, type, reps, target))

####1536 destination

##1S4T
id <- 20
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- c(rep(c(1,3),16),rep(c(2,4),16)) 
target <- 1
LYT.20 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 21
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- rep(c(1,2),32) 
target <- c(rep(1,32), rep(2,32))    
LYT.21 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 22
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- rep(c(1,2),32) 
target <- 1
LYT.22 <- data.frame(cbind(id, well, type, reps, target))


##4S1T
id <- 23
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- 1
target <- c(rep(c(1,2),16), rep(c(3,4),16) )
LYT.23 <- data.frame(cbind(id, well, type, reps, target))

##4S2T
id <- 24
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- 1
target <- c(rep(1,32), rep(2,32))    
LYT.24 <- data.frame(cbind(id, well, type, reps, target))



#####################
## 384 well source no edge
####################

###7 controls
##source
id <- 25
well <- 1:384
type <- c(rep(5,16), rep(c(5,rep(1,14),5), 21),  c(5, rep(1,7), 2,2,2,2,3,3,4,5)  , rep(5,16))
reps <- 1
target <- 1
LYT.25 <- data.frame(cbind(id, well, type, reps, target))


###
##dest 1536

##1S4T
id <- 26
well <- 1:1536
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <- c(rep(c(1,3),16),rep(c(2,4),16)) 
target <- 1
LYT.26 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 27
well <- 1:1536
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <-  c(1,2)
target <- c(rep(1,32), rep(2,32))    
LYT.27 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 28
well <- 1:1536
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <-  c(1,2)
target <- 1
LYT.28 <- data.frame(cbind(id, well, type, reps, target))

##4S1T
id <- 29
well <- 1:1536
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <- 1
target <- c(rep(c(1,2),16), rep(c(3,4),16) )
LYT.29 <- data.frame(cbind(id, well, type, reps, target))

##4S2T
id <- 30
well <- 1:1536
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <- 1
target <- c(rep(1,32), rep(2,32))    
LYT.30 <- data.frame(cbind(id, well, type, reps, target))




###14 controls
##source
id <- 31
well <- 1:384
type <- c(rep(5,16), rep(c(5,rep(1,14),5), 21),  c(5, rep(2,7), rep(3,4), 4,4,4, 5)  , rep(5,16))
reps <- 1
target <- 1
LYT.31 <- data.frame(cbind(id, well, type, reps, target))





type <- c(rep(5,64), rep(c(5,5,rep(1,28),5,5), 42), rep(c(5,5, rep(2,14),rep(3,8), rep(4,6), 5,5),2) ,rep(5,64))

##1S4T
id <- 32
well <- 1:1536
reps <- c(rep(c(1,3),16),rep(c(2,4),16)) 
target <- 1
LYT.32 <- data.frame(cbind(id, well, type, reps, target))

##2S2T
id <- 33
well <- 1:1536
reps <-  c(1,2)
target <- c(rep(1,32), rep(2,32))    
LYT.33 <- data.frame(cbind(id, well, type, reps, target))

##2S4T
id <- 34
well <- 1:1536
reps <-  c(1,2)
target <- 1
LYT.34 <- data.frame(cbind(id, well, type, reps, target))

##4S1T
id <- 35
well <- 1:1536
reps <- 1
target <- c(rep(c(1,2),16), rep(c(3,4),16) )
LYT.35 <- data.frame(cbind(id, well, type, reps, target))

##4S2T
id <- 36
well <- 1:1536
reps <- 1
target <- c(rep(1,32), rep(2,32))    
LYT.36 <- data.frame(cbind(id, well, type, reps, target))



##1536 well plates as source with blank dest

## 
id <- 37
well <- 1:1536
type <- c(rep(1,1488), c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4), rep(1,16)   ,  c(2,2,2,2,2,2,2,2,3,3,3,3,4,4,4,4)  )
reps <- 1
target <- 1
LYT.37 <- data.frame(cbind(id, well, type, reps, target))


id <- 38
well <- 1:1536
type <- c(rep(1,1472), rep(c(rep(2,16), rep(3,8),rep(4,8)),2)  )
reps <- 1
target <- 1
LYT.38 <- data.frame(cbind(id, well, type, reps, target))

## LYT.18
id <- 39
well <- 1:1536
##type <- c(rep(4,64),rep(c(4,4,rep(1,28),4,4),42),  rep( c(4,4, rep(1,14), rep(2,8),3,3,3,3,4,4,4,4),    2), rep(4,64))
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),  rep( c(5,5, rep(1,14), rep(2,8),3,3,3,3,4,4,5,5),    2), rep(5,64))
reps <-  1
target <- 1
LYT.39 <- data.frame(cbind(id, well, type, reps, target))

## LYT.22
id <- 40
well <- 1:1536
##type <- c(rep(4,64),rep(c(4,4,rep(1,28),4,4),42),    rep(c(4,4, rep(2,14), rep(3,8),rep(4,8)),2),  rep(4,64))
type <- c(rep(5,64),rep(c(5,5,rep(1,28),5,5),42),    rep(c(5,5, rep(2,14), rep(3,8),rep(4,6),rep(5,2)),2),  rep(5,64))
reps <-  1
target <- 1
LYT.40 <- data.frame(cbind(id, well, type, reps, target))

id <- 41
well <- 1:1536
type <- rep(4,1536)
reps <-  1
target <- 1
LYT.41 <- data.frame(cbind(id, well, type, reps, target))




final <- rbind(LYT.1, LYT.2, LYT.3, LYT.4, LYT.5, LYT.6, LYT.7, LYT.8,  LYT.9, LYT.10, LYT.11, LYT.12, LYT.13, LYT.14, LYT.15, LYT.16, LYT.17, LYT.18, LYT.19, LYT.20, LYT.21, LYT.22, LYT.23, LYT.24, LYT.25, LYT.26, LYT.27, LYT.28, LYT.29, LYT.30, LYT.31, LYT.32, LYT.33, LYT.34, LYT.35, LYT.36, LYT.37, LYT.38, LYT.39, LYT.40, LYT.41  )

file.name <-"~/syncd/prog/plate-manager/Rutilities/layout_files/plate_layouts_for_import.txt"
file.remove(file.name)

write.table(final, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))










##For jdbc
file.name <-"~/syncd/prog/plate-manager/Rutilities/layout_files/plate_layouts_for_import_jdbc.txt"
file.remove(file.name)

cat("[", file=file.name, append=TRUE)

for (i in 1:nrow(final)){
    if( i == nrow(final)){
        line <- paste("[", final[i,"id"]," ", final[i,"well"]," ", final[i,"type"]," ", final[i,"reps"]," ", final[i,"target"], "]", sep="")        
    }else{
        line <- paste("[", final[i,"id"]," ", final[i,"well"]," ", final[i,"type"]," ", final[i,"reps"]," ", final[i,"target"],"]", sep="")        
    }   
    cat(line, file=file.name, append=TRUE)
}

cat("]", file=file.name, append=TRUE)


column <- sort(rep( 1:48, 32))
row <- rep(c(LETTERS[1:26],"AA","AB","AC","AD","AE","AF"),48)
rownum <- 1:32
well <- 1:1536
plate <- sort(rep(1:20, 1536))
hits <- FALSE

results <- cbind.data.frame(plate, row, rownum, column,  well, response, hits, stringsAsFactors=FALSE)

results

results[results$well %in% c( 1489:1496, 1521:1528),"response"] <- sample(positives, 32, replace=TRUE)
results[results$well %in% c( 1497:1500, 1529:1532),"response"] <- sample(negatives, 16, replace=TRUE)
results[results$well %in% c( 1501:1504, 1533:1536),"response"] <- 0

results[results$response > 0.5, "hits"] <- TRUE


plate1 <- results[results$plate== 1,]
ggplot(plate1, aes(x=column, y=rownum)) + geom_point(aes( color=hits)) + scale_y_continuous(trans = "reverse")

output <- results[,c("plate","well","response")]

file.name <-"~/syncd/prog/plate-manager/plate_data/sample1536.txt" 
write.table(output, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))


## for 20 384 well plates

response <- rbeta(384*20, 2, 6,  0.5)
response

plot(response)


positives <- seq(0.5, 0.65, 0.001)
negatives <- seq(0, 0.2, 0.001)


column <- sort(rep( 1:24, 16))
row <- rep(c(LETTERS[1:16]),24)
rownum <- 1:16
well <- 1:384
plate <- sort(rep(1:20, 384))
hits <- FALSE

results <- cbind.data.frame(plate, row, rownum, column,  well, response, hits, stringsAsFactors=FALSE)

##results

results[results$well %in% c( 353:360, 369:376),"response"] <- sample(positives, 16, replace=TRUE)
results[results$well %in% c( 361:364, 377:380),"response"] <- sample(negatives, 8, replace=TRUE)
results[results$well %in% c( 365:368, 381:384),"response"] <- 0

results[results$response > 0.5, "hits"] <- TRUE


plate1 <- results[results$plate== 1,]
ggplot(plate1, aes(x=column, y=rownum)) + geom_point(aes( color=hits)) + scale_y_continuous(trans = "reverse")

output <- results[,c("plate","well","response")]

file.name <-"~/syncd/prog/plate-manager/plate_data/sample384controls8.txt" 
write.table(output, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))


## 384 4 controls


results[results$well %in% c( 361:364, 377:380),"response"] <- sample(positives, 16, replace=TRUE)
results[results$well %in% c( 365:366, 381:382),"response"] <- sample(negatives, 8, replace=TRUE)
results[results$well %in% c( 367:368, 383:384),"response"] <- 0

results[results$response > 0.5, "hits"] <- TRUE


plate1 <- results[results$plate== 2,]
ggplot(plate1, aes(x=column, y=rownum)) + geom_point(aes( color=hits)) + scale_y_continuous(trans = "reverse")

output <- results[,c("plate","well","response")]

file.name <-"~/syncd/prog/plate-manager/plate_data/sample384controls4.txt" 
write.table(output, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))



## for 20 96 well plates

response <- rbeta(96*20, 2, 6,  0.5)

plot(response)


positives <- seq(0.5, 0.65, 0.001)
negatives <- seq(0, 0.2, 0.001)


column <- sort(rep( 1:12, 8))
row <- rep(c(LETTERS[1:8]),12)
rownum <- 1:8
well <- 1:96
plate <- sort(rep(1:20, 96))
hits <- FALSE

results <- cbind.data.frame(plate, row, rownum, column,  well, response, hits, stringsAsFactors=FALSE)

########
results[results$well %in% c( 89:92),"response"] <- sample(positives, 16, replace=TRUE)
results[results$well %in% c( 93, 94),"response"] <- sample(negatives, 8, replace=TRUE)
results[results$well %in% c( 95, 96),"response"] <- 0

results[results$response > 0.5, "hits"] <- TRUE


plate1 <- results[results$plate== 1,]
ggplot(plate1, aes(x=column, y=rownum)) + geom_point(aes( color=hits)) + scale_y_continuous(trans = "reverse")

output <- results[,c("plate","well","response")]

file.name <-"~/syncd/prog/plate-manager/plate_data/sample96controls8.txt" 
write.table(output, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))


##  96 4 controls

results[results$well %in% c( 93,94),"response"] <- sample(positives, 40, replace=TRUE)
results[results$well %in% c( 95),"response"] <- sample(negatives, 20, replace=TRUE)
results[results$well %in% c( 96),"response"] <- 0

results[results$response > 0.5, "hits"] <- TRUE


plate1 <- results[results$plate== 1,]
ggplot(plate1, aes(x=column, y=rownum)) + geom_point(aes( color=hits)) + scale_y_continuous(trans = "reverse")

output <- results[,c("plate","well","response")]

file.name <-"~/syncd/prog/plate-manager/plate_data/sample96controls4.txt" 
write.table(output, file = file.name, append = FALSE, quote = FALSE, sep = "\t",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))

