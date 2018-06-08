#!/usr/bin/python

import os
import sys

def main(argv):
  format_data_for_hive(argv[1], argv[2] + '/' + os.path.basename(argv[1]))

def format_data_for_hive(filename, out_file):
  f = open(filename, 'r')
  fout = open(out_file, 'w')
  first = True
  num = 0
  data = ""
  for line in f:
    #if first:
    #  first = False
    #else:
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
