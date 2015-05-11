import os,re

version_h = os.path.join(os.path.dirname(__file__), '..', 'src',
    'version.h')

f = open(version_h)

for line in f:
  if re.match('#define NUBJS_MAJOR_VERSION', line):
    major = line.split()[2]
  if re.match('#define NUBJS_MINOR_VERSION', line):
    minor = line.split()[2]
  if re.match('#define NUBJS_PATCH_VERSION', line):
    patch = line.split()[2]

print '%(major)s.%(minor)s.%(patch)s'% locals()
