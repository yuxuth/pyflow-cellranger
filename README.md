# pyflow-cellranger
a snakemake pipeline to process 10x genomics data using [cellranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger).

```
snakemake -p -j 555 --cluster-config cluster.json \
--cluster "sbatch  -p common,scavenger -J {cluster.job} --mem={resources.mem_gb}G -N 1 -n {threads} -o {cluster.out} -e {cluster.err} " &> log 
```


need to confirm --mem={resources.mem_gb} do the right thing. may need G after the mem_gb
