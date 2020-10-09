shell.prefix("set -eo pipefail; echo BEGIN at $(date); ")
shell.suffix("; exitstat=$?; echo END at $(date); echo exit status was $exitstat; exit $exitstat")

import subprocess
import csv
import os
configfile: "config.yaml"


FILES = json.load(open(config['SAMPLES_JSON']))

SAMPLES = sorted(FILES.keys())

cellranger = config['cellranger']

COUNT = []
for sample in SAMPLES:
	COUNT.append("count_stamps/" + sample + ".stamp")
h5 = []
for sample in SAMPLES:
    h5.append("output_files/" + sample + ".filtered_feature_bc_matrix.h5")
html = []
for sample in SAMPLES:
    html.append("output_files/" + sample + ".web_summary.html")

TARGETS = []


TARGETS.extend(html)
TARGETS.extend(h5)

localrules: all, cp_result
rule all:
    input: TARGETS


rule count:
	input: directory(lambda wildcards: FILES[wildcards.sample])
	output: "count_stamps/{sample}.stamp"
	log: "00log/{sample}_cellranger_count.log"
	threads: 24
	resources:
		mem_gb=120
	shell:
		"""
		{cellranger} count --id={wildcards.sample}_count \
                 --transcriptome={config[transcriptome]} \
                 --fastqs={input} \
                 --sample={wildcards.sample} \
                 --chemistry=SC3Pv3 \
                 --expect-cells=10000 \
                 --localcores={threads} \
                 --localmem={resources.mem_gb} > {log}
  		touch {output}
		"""

rule cp_result:
    input : "count_stamps/{sample}.stamp"
    output: "output_files/{sample}.filtered_feature_bc_matrix.h5",
            "output_files/{sample}.web_summary.html"
    shell:
        """
        cp  {wildcards.sample}_count/outs/filtered_feature_bc_matrix.h5  {output[0]}
        cp   {wildcards.sample}_count/outs/web_summary.html {output[1]}
        """
