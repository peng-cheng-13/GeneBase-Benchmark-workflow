#!/usr/bin/python

import json
import sys
import os
import alluxio
import time
from alluxio import option

def main(argv):
  format_data_for_mahout(argv[1], argv[2] + '/' + os.path.basename(argv[1]) + '_mahout')

def format_data_for_mahout(filename, out_file):
  num = 0
  data = ""
  client = alluxio.Client('localhost', 39999)
  with client.open(filename, 'r') as f:
    with client.open(out_file, 'w') as fout:
      for line in f:
	parts = line.split()
	parts[2] = "{0:.2f}".format(float(parts[2])) # special because original #s have precision of only 2 places after decimal
	if (num > 20000):
	  fout.write(data)
          data = ""
          num = 1
          data = data + ','.join(parts) + '\n'
        else:
          data = data + ','.join(parts) + '\n'
          num = num + 1
      fout.write(data)
      print 'Done'

if __name__ == "__main__":
  main(sys.argv)
