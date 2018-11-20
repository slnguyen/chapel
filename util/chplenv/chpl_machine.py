#!/usr/bin/env python
import collections
import optparse
import os
import platform
from string import punctuation
from sys import stderr, stdout
import sys

chplenv_dir = os.path.dirname(__file__)
sys.path.insert(0, os.path.abspath(chplenv_dir))

import chpl_arch, overrides
from utils import memoize

@memoize
def get(flag='host'):

    if flag == 'host':
        machine_val = overrides.get('CHPL_HOST_MACHINE', '')
    elif flag == 'target':
        machine_val = overrides.get('CHPL_TARGET_MACHINE', '')
    else:
        error("Invalid flag: '{0}'".format(flag), ValueError)

    if machine_val:
        return machine_val

    # compute the default
    return chpl_arch.get_default_machine(flag)

def _main():
    parser = optparse.OptionParser(usage="usage: %prog [--host|target]")
    parser.add_option('--target', dest='location', action='store_const',
                      const='target', default='target')
    parser.add_option('--host', dest='location', action='store_const',
                      const='host')
    (options, args) = parser.parse_args()

    machine = get(options.location)

    stdout.write("{0}\n".format(machine))

if __name__ == '__main__':
    _main()
