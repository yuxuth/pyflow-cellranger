shell.prefix("set -eo pipefail; echo BEGIN at $(date); ")
shell.suffix("; exitstat=$?; echo END at $(date); echo exit status was $exitstat; exit $exitstat")

import subprocess
import csv
import os
configfile: "config.yaml"


FILES = json.load(open(config['SAMPLES_JSON']))

SAMPLES = sorted(FILES.keys())



COUNT = []
for sample in SAMPLES:
	COUNT.append("count_stamps/" + sample + ".stamp")


TARGETS = []


TARGETS.extend(COUNT)


localrules: all
rule all:
    input: TARGETS

## if the bcl files are in BaseSpace, need to download
## the downloaded folder is named with the run_id


rule count:
	input: directory(lambda wildcards: FILES[wildcards.sample])
	output: "count_stamps/{sample}.stamp"
	log: "00log/{sample}_cellranger_count.log"
	threads: 4
	shell:
		"""
		cellranger count --id={input}_count \
                 --transcriptome={config[transcriptome]} \
                 --fastqs={wildcards.sample} \
                 --sample={wildcards.sample} \
                 --chemistry=SC3Pv3 \
                 --expect-cells=10000 \
                 --localcores={threads} \
                 --localmem=10 > {log}
  		touch {output}
		"""


