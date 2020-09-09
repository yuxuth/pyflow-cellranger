# pyflow-cellranger
a snakemake pipeline to process 10x genomics data using [cellranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger).

```
snakemake -p -j 24 --cluster-config cluster.json \
--cluster "sbatch -J {cluster.job} --mem={cluster.mem} -N 1 -n {threads} -o {cluster.out} -e {cluster.err} " &> log 
```
