# Is it 7PET?
Identifying whether a cholera sample belongs to the seventh pandemic El tor (7PET) sub-lineage based on sequencing data or an assembly. This method is most appropriate where you have a small number of _Vibrio cholerae_ samples you would like to identify as 7PET or non-7PET without having to build a tree using contextual genomes.

![Vibrio cholerae wondering if it is 7PET](/AmI7PET.png)

## Installation
Dependencies: 
- snippy/4.6.0
- ariba/release-v2.14.6
- snp-dists/0.7.0
- blast/2.14.1
- r/3.6.0
- mash/2.1.1

```
git clone https://github.com/amberjoybarton/is-it-7pet IsIt7PET
```
## Usage
```
cd IsIt7PET
chmod 777 ./find7PET.sh
```
Input a tab-delimited file containing sample ids and the file locations of your fastq files or assemblies. Assemblies must end with the file extension ".fa".

```
Sample_A    Sample_A_R1.fastq.gz    Sample_A_R2.fastq.gz
Sample_B    Sample_B_R1.fastq.gz    Sample_B_R2.fastq.gz
Sample_C    Sample_C_assembly.fa
Sample_D    Sample_D_assembly.fa
```
There are three options when running the script. The first and fastest is identifying 7PET lineage samples on the basis of the presence/absence of key genes:
```
./find7PET.sh inputfile.txt
```
The second fastest option will also use mash to assess how similar a sample is (% shared hashes) to 7PET reference genome N16961. 

```
./find7PET.sh inputfile.txt dist_mash
```
The slowest but most accurate option will use snippy and snp-dists to find the SNP distance from 7PET reference genome N16961. 

```
./find7PET.sh inputfile.txt dist_snippy
```

## Output
This script will output a file "Is_it_7PET.txt" summarising for each sample whether it contains the genes VC2346 (7PET specific), ctxA or ctxB (toxigenic _V. cholerae_ specific). Depending on the option selected, it may also indicate the shared % hashes with 7PET reference genome N16961 (the higher this is, the more likely the sample is to be 7PET) or the SNP distance from N16961 (the lower this is, the more likely the sample is to be 7PET).

| Sample   | VC2346 | ctxA | ctxB  | N16961_shared_hashes | dist_N16961 | Is_7PET |
| -------- | ------ | ---- | ----  |  -------------------- | ---------- | --------|
| Sample_A | Yes | Yes | Yes | 89.9 | 153 | Yes
| Sample_B  | No | No | No | 45.6 | 50163 | No
| Sample_C | No | No | No | 51.8| 51998 | No
| Sample_D  | Yes | Yes | Yes | 98.0 | 90 | Yes
