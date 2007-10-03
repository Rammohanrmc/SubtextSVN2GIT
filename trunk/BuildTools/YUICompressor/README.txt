==============================================================================
YUI Compressor
==============================================================================

NAME

  yuicompressor - The Yahoo! JavaScript Compressor

SYNOPSIS

  java -jar yuicompressor.jar
      [-h, --help] [--warn] [--nomunge]
      [--charset character-set] [-o outfile] infile

DESCRIPTION

  YUI Compressor is a JavaScript compressor which, in addition to minifying,
  obfuscates local variables using the smallest possible variable name. This
  obfuscation is safe, even when using constructs such as 'eval' or 'with'
  (although the compression is not optimal is those cases) Compared to jsmin,
  the average savings is around 20% (10% after gzipping)

OPTIONS

  -h, --help
      Prints help on how to use the YUI Compressor

  --warn
      Prints additional warnings such as duplicate variable declarations,
      missing variable declaration, unrecommended practices, etc.

  --nomunge
      Minify only. Do not obfuscate local symbols.

  --charset character-set
      If a supported character set is specified, the YUI Compressor will use it
      to read the input file. Otherwise, it will assume that the platform's
      default character set is being used. The output file is encoded using
      the same character set.

  -o outfile
      Place output in file outfile. If not specified, the YUI Compressor will
      place the output in a file which name is made of the input file name,
      the "-min" suffix and the "js" extension.

NOTES

  YUI Compressor requires Java version >= 1.4.

AUTHOR

  The YUI Compressor was written and is maintained by:
      Julien Lecomte <jlecomte@yahoo-inc.com>

COPYRIGHT

  Copyright (c) 2007, Yahoo! Inc. All rights reserved.
  Code licensed under the BSD License:
      http://developer.yahoo.net/yui/license.txt
