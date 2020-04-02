#!/usr/bin/env python3

import json
import os
import re
from os.path import join
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser()
parser.add_argument("--fastq_dir", help="Required. the FULL path to the fastq folder")
args = parser.parse_args()

assert args.fastq_dir is not None, "please provide the path to the fastq folder"


## default dictionary is quite useful!

FILES = defaultdict(lambda: defaultdict(list))

## build the dictionary with full path for each fastq.gz file
# for root, dirs, files in os.walk(args.fastq_dir):
#     for file in files:
#         if file.endswith("fq.gz"):
#             full_path = join(root, file)
#             m = re.search(r"(.*)_(L[0-9]{3})_(R[12])_[0-9]{3}.fq.gz",file)
#             if m:
#                 sample = m.group(1)
#                 FILES[sample]= sample
for root, dirs, files in os.walk(args.fastq_dir):
    for dir in dirs:
        if len(dir) >0:
            for i in dir:
                full_path = join(root, dir)
                FILES[dir] = full_path

# make sure R1 and R2 from different lanes are ordered in the same way
# e.g. L001_R1 should pair with L001_R2, L002_R1 pair with L002_R2      

FILES_sorted = FILES



print()
print ("total {} unique samples will be processed".format(len(FILES.keys())))
print ("------------------------------------------")
for sample in FILES_sorted.keys():
    for read in sorted(FILES_sorted[sample]):
        print ("{sample} directed".format(sample = sample))
print ("------------------------------------------")
print("check the samples.json file for fastqs belong to each sample")
print()

js = json.dumps(FILES_sorted, indent = 4, sort_keys=True)
open('samples.json', 'w').writelines(js)


