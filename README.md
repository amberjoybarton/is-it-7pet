# Is it 7PET?
Identifying whether a cholera sample belongs to the seventh pandemic El tor (7PET) sub-lineage based on sequencing data or an assembly. This method is most appropriate where you have a small number of _Vibrio cholerae_ samples you would like to identify as 7PET or non-7PET without having to build a tree using contextual genomes.

## Installation
Dependencies: 
- snippy/4.6.0
- ariba/release-v2.14.6
- snp-dists/0.7.0--hed695b0_0
- blast/2.14.1--pl5321h6f7f691_0
- r/3.6.0

```
git clone https://github.com/amberjoybarton/is-it-7pet IsIt7PET
```
## Usage
```
cd IsIt7PET
```
Input a tab-delimited file containing sample ids and the file locations of your fastq files or assemblies. Assemblies must end with the file extension ".fa".

```
Sample_A    Sample_A_R1.fastq.gz    Sample_A_R2.fastq.gz
Sample_B    Sample_B_R1.fastq.gz    Sample_B_R2.fastq.gz
Sample_C    Sample_C_assembly.fa
Sample_D    Sample_D_assembly.fa
```
Run the bash script:
```
./find7PET.sh inputfile.txt
```
## Output
This script will output a file summarising for each sample whether it contains the genes VC2346 (7PET specific), ctxA or ctxB (toxigenic _V. cholerae_ specific). It will also indicate the SNP distance from 7PET reference genome N16961, where a distance below 300 is indicative of a sample belonging to the 7PET sub-lineage.


| Sample   | VC2346 | ctxA | ctxB  | dist_N16961 | Is_7PET |
| -------- | ------ | ---- | ----  |  ---------- | ------- |
| Sample_A | Yes | Yes | Yes | 153 | Yes
| Sample_B  | No | No | No | 50163 | No
| Sample_C | No | No | No | 51998 | No
| Sample_D  | Yes | Yes | Yes | 90 | Yes
