#access cluster
ssh carlsonlab@pod.cnsi.ucsb.edu
#enter password

#Upload files to cluster
scp -r Elisa.zip carlsonlab@pod.cnsi.ucsb.edu:/home/carlsonlab/elisa/
scp -r silva_nr99_v138.1_wSpecies_train_set.fa.gz carlsonlab@pod.cnsi.ucsb.edu:/home/carlsonlab/elisa/

#to unzip all .zip files
unzip '*.zip'

#move silva database from one folder to another
mv *.fa.gz home/carlsonlab/elisa/

#make filtered directory for DADA2
mkdir filtered

#move silva database to folder
mv *.fa.gz /home/carlsonlab/elisa

#activate conda environment with R
conda activate R4.2.0

#submit batch job to slurm to run dada2 pipeline
sbatch \
	--job-name=elisa_dada2 \
	--nodes=1 \
	--tasks-per-node=32 \
	--cpus-per-task=1 \
	--mem=60G \
	--time=3:00:00 \
	--output=dada2_out \
	--error=dada2_err \
	--wrap="Rscript dada.R"

#after dada2 pipeline finishes, move dada2 output files to their own folder for organization
mkdir dada2_output
mv *.txt dada2_output
mv *.fasta dada2_output
mv *.rds dada2_output
mv dada2_err dada2_output
mv dada2_out dada2_output

#move fastqs into their own folder
mkdir fastqs
mv *fastq.gz fastqs

#after the dada2 pipeline finishes running, in a local terminal type the following commands to download the dada2 output files
scp -r carlsonlab@pod.cnsi.ucsb.edu:/home/carlsonlab/elisa/dada2_output /Users/elisaromanelli/Desktop/
