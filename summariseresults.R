summary = as.data.frame(matrix(ncol = 4, nrow = 0))
colnames(summary) = c("Sample", "VC2346", "ctxA", "ctxB")

ariba = list.files("ariba_results")
if(length(ariba) > 0){
for(i in ariba){
summary[nrow(summary)+1,1:4] = c(gsub("7petariba_", "", i), "No", "No", "No")
x = read.table(paste0("ariba_results/",i), comment.char = "/", header = T)
summary[nrow(summary), which(colnames(summary) %in% x$X.ariba_ref_name)] = "Yes"}}

blast = list.files("blast_results")
if(length(blast) > 0){
for(i in blast){
summary[nrow(summary)+1,1:4] = c(gsub("7petblast_", "", i), "No", "No", "No")
x = read.table(paste0("blast_results/",i), header = F)
summary[nrow(summary),which(colnames(summary)%in% x[which(x$V3 > 90),"V2"])] = "Yes"}}

mash = list.files("mash_results")
if(length(mash) > 0){
summary$N16961_shared_hashes = NA
for(i in mash){
x = read.table(paste0("mash_results/", i), comment.char = "{")
x$V2 = gsub("7petmash_", "", i)
x$V5 = as.numeric(gsub("[/]1000", "", x$V5))/10
summary[which(summary$Sample == x$V2), "N16961_shared_hashes"] = as.character(x[,"V5"])
}}

if(length(list.files(pattern="distanceref.txt")) > 0){
dist = read.table("distanceref.txt", fill = T, header = T,  comment.char = "/")
summary = merge(summary, dist, by.x = "Sample", by.y = "snp.dists", all.x = T)
colnames(summary)[ncol(summary)] = "dist_N16961"}

summary$Is_7PET = "Maybe"

if(length(grep("dist_N16961", colnames(summary))) > 0){
summary[which(summary$VC2346 == "Yes" & summary$ctxA == "Yes" & summary$ctxB == "Yes" & summary$dist_N16961 < 400), "Is_7PET"] = "Yes"
summary[which(summary$dist_N16961 > 10000),"Is_7PET"] = "No"
}else if(length(grep("N16961_shared_hashes", colnames(summary))) > 0 & length(grep("dist_N16961", colnames(summary))) == 0){
summary[which(summary$VC2346 == "Yes" & summary$ctxA == "Yes" & summary$ctxB == "Yes" & summary$N16961_shared_hashes > 80), "Is_7PET"] = "Yes"
summary[which(summary$N16961_shared_hashes < 60), "Is_7PET"] = "No"} else{
summary[which(summary$VC2346 == "Yes" & summary$ctxA == "Yes" & summary$ctxB == "Yes"), "Is_7PET"] = "Yes"
summary[which(summary$VC2346 == "No" & summary$ctxA == "No" & summary$ctxB == "No"), "Is_7PET"] = "No"
}

write.table(summary, file = "Is_it_7PET.txt", sep = "\t", quote = F, row.names = F)
