#!/bin/bash
#SBATCH -o count.demultiplex.o.%J    # Job output file
#SBATCH -e count.demultiplex.e.%J    # Job error file
#SBATCH --ntasks=1            # number of parallel processes (tasks)
#SBATCH --qos=bbdefault       # selected queue
#SBATCH --time=00:05:00        # time limit

set -e

module purge
module load bear-apps/2023a/live

touch count_demultiplexed.txt

for f in 16SV4_revcomp/*R1.fastq.gz
do
    c=$(zcat $f | grep @ | wc -l)
    echo $f $c >> count_demultiplexed.txt
done

