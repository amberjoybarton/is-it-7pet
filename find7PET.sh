hostname=$(hostname)
if [[ $hostname == *"farm"* || $hostname == *"pcs"* || $hostname == *"node"* ]]; then
	module load snippy/4.6.0
	module load ariba/release-v2.14.6
	module load snp-dists/0.7.0--hed695b0_0
	module load blast/2.14.1--pl5321h6f7f691_0
	module load r/3.6.0
	module load mash/2.1.1--he518ae8_0
fi


#Use ariba and blast to check whether key genes are present
mkdir ariba_results
mkdir blast_results
cat $1 | while read line
do
    name=$(echo "$line" | awk '{print $1}')
    r1=$(echo "$line" | awk '{print $2}')
    r2=$(echo "$line" | awk '{print $3}')
   
    # Check if object1 ends with "fastq", "fastq.gz", "fq" or "fq.gz"
    if [[ $r1 =~ \.(fastq|fq)(\.gz)?$ ]]; then
        # Run code for fastq/fq files
        echo "Searching for 7PET genes in sequence data: $r1"
        ariba run 7petmarkers $r1 $r2 ariba_full_${name}
        cut -f1,10 ariba_full_${name}/report.tsv | uniq > ariba_results/7petariba_${name}
        rm -r ariba_full_${name}
        
    # Check if object1 ends with "fa"
    elif [[ $r1 =~ \.fa$ ]]; then
        # Run code for fa files
        echo "Searching for 7PET genes in assembly: $r1"
        blastn -query $r1 -subject 7petmarkers/02.cdhit.all.fa -outfmt "6 qseqid sseqid pident " -out blast_results/7petblast_${name}
    else
        echo "Unknown file type for read 1: $r1"
    fi
 done

#Use mash to check shared hashes with the reference
if [ "$2" = "dist_mash" ]; then
mkdir mash_results

cat $1 | while read line
do
    name=$(echo "$line" | awk '{print $1}')
    r1=$(echo "$line" | awk '{print $2}')
    r2=$(echo "$line" | awk '{print $3}')
   
    # Check if object1 ends with "fastq", "fastq.gz", "fq" or "fq.gz"
    if [[ $r1 =~ \.(fastq|fq)(\.gz)?$ ]]; then
        # Run code for fastq/fq files
        echo "Calculating shared hashes between N16961 and sequence data: $r1"
        cat $r1 $r2 | mash sketch -m 2 -
	mash dist N16961.fa.msh stdin.msh > mash_results/7petmash_${name}

        
    # Check if object1 ends with "fa"
    elif [[ $r1 =~ \.fa$ ]]; then
        # Run code for fa files
        echo "Calculating shared hashes between N16961 and assembly: $r1"
        mash dist N16961.fa.msh $r1 > mash_results/7petmash_${name}
    else
        echo "Unknown file type for read 1: $r1"
    fi
 done
fi

if [ "$2" = "dist_snippy" ]; then
echo "Calculating distance from N16961 using snippy"
snippy-multi $1 --ref N16961.fa --cpus 16 > runme.sh
chmod 777 *
./runme.sh
find . -type f -name "snps.consensus.subs.fa" -exec dirname {} \; | sort -u | xargs rm -r
snippy-clean_full_aln core.full.aln > clean.full.aln
snp-dists clean.full.aln | awk '{print $1, $NF}' | head -n -1 > distanceref.txt
rm core*
rm clean*
fi

Rscript summariseresults.R
rm -rf ariba_results blast_results distanceref.txt runme.sh mash_results
