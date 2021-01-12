# pyflow-cellranger
a snakemake pipeline to process 10x genomics data using [cellranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger).

create fq, create each fq into one folder

```
for i in $(ls *R1*)
do
fold=$(basename $i _S1_L001_R1_001.fastq.gz)
mkdir -p $fold
mv ${fold}*.gz $fold
done
```

```
snakemake -p -j 555 --cluster-config cluster.json \
--cluster "sbatch  -p common,scavenger -J {cluster.job} --mem={cluster.mem} -N 1 -n {threads} -o {cluster.out} -e {cluster.err} " &> log 
```
the name of fq need to be like  SampleName_S1_L001_R1_001.fastq.gz

need to confirm --mem={resources.mem_gb} do the right thing. may need G after the mem_gb

```
snakemake -p -j 555 --cluster-config cluster.json \
--cluster "sbatch  -p common,scavenger -J {cluster.job} --mem={resources.mem_gb}G -N 1 -n {threads} -o {cluster.out} -e {cluster.err} " &> log 
```


clear up after
```
rm -fr *_count/SC_RNA_COUNTER_CS
rm -fr *_count/outs/analysis/ &
rm -fr *_count/outs/possorted_genome_bam.bam* & # may need for velocity analysis
```
