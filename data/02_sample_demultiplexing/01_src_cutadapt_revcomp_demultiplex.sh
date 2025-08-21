#!/bin/bash
#SBATCH -o cutadapt.revcomp.demultiplex.o.%J    # Job output file
#SBATCH -e cutadapt.revcomp.demultiplex.e.%J    # Job error file
#SBATCH --ntasks=4            # number of parallel processes (tasks)
#SBATCH --qos=bbdefault       # selected queue
#SBATCH --time=72:00:00        # time limit

set -e

module purge
module load bear-apps/2023a
module load cutadapt/4.9-GCCcore-12.3.0

## 16SV4
export input_dir=/rds/projects/c/cambonm-oak-syncoms/250730_SynCom_stability_experiment/01_raw_data/PE250/X204SC24085297-Z01-F003/01.RawData/pool_1/
export output_dir=16SV4_revcomp
mkdir $output_dir

# --cores=0 auto detects the number of available cores
# --revcomp searchs for primers and adapters in both orientations

cutadapt \
    -e 0.15 --no-indels \
    --cores=0 \
    --revcomp \
    -g file:tag_primers_16SV4_fwd.fasta \
    -G file:tag_primers_16SV4_rev.fasta \
    -o $output_dir/{name1}-{name2}.R1.fastq.gz -p $output_dir/{name1}-{name2}.R2.fastq.gz \
    $input_dir/pool_1_1.fq.gz $input_dir/pool_1_2.fq.gz
