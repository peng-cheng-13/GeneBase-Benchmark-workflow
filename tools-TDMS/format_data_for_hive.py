#!/usr/bin/python

import json
import sys
import os
import alluxio
import time
from alluxio import option


def main(argv):
  format_data_for_hive(argv[1], argv[2] + '/' + os.path.basename(argv[1]))

def format_data_for_hive(filename, out_file):
  client = alluxio.Client('localhost', 39999)
  first = True
  num = 0
  data = ""
  with client.open(filename, 'r') as f:
    with client.open(out_file, 'w') as fout:
      for line in f:
        parts = line.split(', ')
	if (num > 20000):
	   fout.write(data)
	   data = ""
	   num = 1
	   data = data + ','.join(parts)
	else:
	   data = data + ','.join(parts)
	   num = num + 1
      
      fout.write(data)
      print 'Done'


if __name__ == "__main__":
  main(sys.argv)
