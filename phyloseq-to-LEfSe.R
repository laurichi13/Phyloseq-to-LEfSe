#Phyloseq to LEfSe 
stringsAsFactors = FALSE
library(tidyverse)
library(phyloseq)
library(janitor)


tax <- as.data.frame(t(physeq@otu_table@.Data))
tax <- rownames_to_column(tax, var="ASV")
names <- as.data.frame(physeq@tax_table@.Data)
names <- names %>% unite(Kingdom,Phylum,Class,Order,Family,Genus,col=Genus,sep="|")
names <- rownames_to_column(names, var="ASV")
tax <- names %>% select(ASV,Genus) %>% left_join(tax)
tax$ASV <- NULL
tax <- t(tax)
tax <- tax %>% row_to_names(row_number=1)
tax <- as.data.frame(tax)
tax <- rownames_to_column(tax, var="SampleID")

#Metadata 
metadata <- as.data.frame(physeq@sam_data)
write_csv(metadata,"metadata.csv") #Select classes
metadata <- read_csv("Juliana/metadata.csv")
tax <- metadata %>% left_join(tax)
lefse <- t(tax)
lefse[is.na(lefse)] <- 0
lefse <-rownames_to_column(as.data.frame(lefse))

#Export
write_tsv(lefse, "lefse.txt",col_names = F) 

