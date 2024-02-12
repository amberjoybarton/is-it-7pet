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

dist = read.table("distanceref.txt", fill = T, header = T,  comment.char = "/")
summary = merge(summary, dist, by.x = "Sample", by.y = "snp.dists", all.x = T)
colnames(summary)[5] = "dist_N16961"
summary$Is_7PET = "Maybe"
summary[which(summary$VC2346 == "Yes" & summary$ctxA == "Yes" & summary$ctxB == "Yes" & summary$dist_N16961 < 400), "Is_7PET"] = "Yes"
summary[which(summary$dist_N16961 > 10000),"Is_7PET"] = "No"
write.table(summary, file = "Is_it_7PET.txt", sep = "\t", quote = F, row.names = F)
