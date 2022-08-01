#Upload files to cluster
scp -r Elisa.zip carlsonlab@pod.cnsi.ucsb.edu:/home/carlsonlab/elisa/
scp -r silva_nr99_v138.1_wSpecies_train_set.fa.gz carlsonlab@pod.cnsi.ucsb.edu:/home/carlsonlab/elisa/

#to unzip all .zip files
unzip '*.zip'

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
