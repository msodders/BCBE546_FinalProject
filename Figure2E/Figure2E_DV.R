install.packages("ggplot2")
install.packages("dplyr")
library("ggplot2")
library("dplyr")

UniqueInsertions <- read.delim("TSASResults.txt")


# Just First Column with All rows
df = UniqueInsertions[, c(2,4,5)]

#divdes reads into thousands 

df["X1000"] <- df$X/1000

#Check dataframe
df

#plot using ggplot
p <- ggplot(data=df, aes(x=Enrichment, y=X1000, group=Number, shape=Number, color=Number)) +
  geom_point(aes(shape= Number), size=2) +
  scale_shape_manual(values=c(16, 15)) + 
  scale_color_manual(values=c("No. Of Unique Insertions"= "black", "No. Of Unique Insertions Within Genes" = "red")) +
  geom_line(aes(color=Number))+
  xlab('Enrichment') +
  ylab('Unique Insertions (thousands)') + 
  ylim(0, 5) + 
  theme(legend.title = element_blank()) +
  annotate(geom="text", x=0, y=2.8, label="80",
           color="black") + 
  annotate(geom="text", x=1, y=1.9, label="82",
         color="black") + 
  annotate(geom="text", x=2, y=1.0, label="87",
           color="black") + 
  annotate(geom="text", x=3, y=0.8, label="88",
           color="black") + 
  theme_bw()

p

