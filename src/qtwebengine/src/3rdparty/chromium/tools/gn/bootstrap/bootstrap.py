#!/usr/bin/env python
# Copyright 2014 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This file isn't officially supported by the Chromium project. It's maintained
# on a best-effort basis by volunteers, so some things may be broken from time
# to time. If you encounter errors, it's most often due to files in base that
# have been added or moved since somebody last tried this script. Generally
# such errors are easy to diagnose.
"""Builds gn and generates Chromium's build files.

This script should only be run from a Chromium tarball.  It will not work in a
regular git checkout.  In a regular git checkout, a gn binary is pulled via
DEPS.  To build gn from source in a regular checkout, see
https://gn.googlesource.com/gn/
"""

# This script may be removed if/when gn becomes available in the standard
# repositories for several mainstream Linux distributions.

import optparse
import os
import shutil
import subprocess
import sys

BOOTSTRAP_DIR = os.path.dirname(os.path.abspath(__file__))
GN_ROOT = os.path.dirname(BOOTSTRAP_DIR)
SRC_ROOT = os.path.dirname(os.path.dirname(GN_ROOT))


def main(argv):
  parser = optparse.OptionParser(description=sys.modules[__name__].__doc__)
  parser.add_option(
      '-d',
      '--debug',
      action='store_true',
      help='Do a debug build. Defaults to release build.')
  parser.add_option(
      '-o', '--output', help='place output in PATH', metavar='PATH')
  parser.add_option('-s', '--no-rebuild', help='ignored')
  parser.add_option('--no-clean', help='ignored')
  parser.add_option('--gn-gen-args', help='Args to pass to gn gen --args')
  parser.add_option(
      '--build-path',
      help='The directory in which to build gn, '
      'relative to the src directory. (eg. out/Release)')
  parser.add_option(
      '--with-sysroot',
      action='store_true',
      help='Download and build with the Debian sysroot.')
  parser.add_option('-v', '--verbose', help='ignored')
  parser.add_option(
      '--skip-generate-buildfiles',
      action='store_true',
      help='Do not run GN after building it. Causes --gn-gen-args '
      'to have no effect.')
  options, args = parser.parse_args(argv)
  if args:
    parser.error('Unrecognized command line arguments: %s.' % ', '.join(args))

  if options.build_path:
    build_rel = options.build_path
  elif options.debug:
    build_rel = os.path.join('out', 'Debug')
  else:
    build_rel = os.path.join('out', 'Release')
  out_dir = os.path.join(SRC_ROOT, build_rel)
  gn_path = options.output or os.path.join(out_dir, 'gn')
  gn_build_dir = os.path.join(out_dir, 'gn_build')

  cmd = [
      sys.executable,
      os.path.join(GN_ROOT, 'build', 'gen.py'),
      '--no-last-commit-position',
      '--out-path=' + gn_build_dir,
  ]
  if not options.with_sysroot:
    cmd.append('--no-sysroot')
  if options.debug:
    cmd.append('--debug')
  subprocess.check_call(cmd)

  shutil.copy2(
      os.path.join(BOOTSTRAP_DIR, 'last_commit_position.h'), gn_build_dir)
  subprocess.check_call(
      ['ninja', '-C', gn_build_dir, 'gn', '-w', 'dupbuild=err'])
  shutil.copy2(os.path.join(gn_build_dir, 'gn'), gn_path)

  if not options.skip_generate_buildfiles:
    gn_gen_args = options.gn_gen_args or ''
    if not options.debug:
      gn_gen_args += ' is_debug=false'
    subprocess.check_call([
        gn_path, 'gen', out_dir,
        '--args=%s' % gn_gen_args, "--root=" + SRC_ROOT
    ])


if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))
