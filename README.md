# pdf2fxl – A PDF to Fixed Layout EPUB Converter

## Prerequisites

1.  [Poppler](http://poppler.freedesktop.org/), in particular poppler’s
    `pdftohtml` binary
2.  [ImageMagick](http://www.imagemagick.org/)

Poppler and ImageMagick are available for many package managers,
including Cygwin’s. We made sure that the Bash front-end script runs on
the Oracle Java for Windows / Cygwin combo. We have also tried to avoid
utilities/options such as `readlink -f` that are known to not work on
vanilla Mac OS X / BSD systems. However, we didn’t try it yet on a Mac
and we’d like to hear from you whether it’s woking there.

The other prerequisites are Java 1.6 (or newer) and bash. Sorry no
Windows batch file at the moment. But you may figure out the Poppler,
ImageMagick, and Calabash invocation by peeking into the [bash
script](https://subversion.le-tex.de/common/pdf2fxl/pdf2fxl.sh). The
[Calabash](http://xmlcalabash.com/) processor is included as an svn
external, and so are [le-tex
transpect](http://www.le-tex.de/en/transpect.html)’s XProc/XSLT modules
for building EPUBs, etc.

## Invocation

`./pdf2fxl.sh -i sample-input/demojam.pdf -d -e`

(Call it without arguments to see a brief help text.)

You will find the resulting epub in
`sample-input/demojam/demojam.wrap.epub`.

## Sample Input/Output

You may download the [source PDF](https://subversion.le-tex.de/common/pdf2fxl/sample-input/demojam.pdf)
and its [EPUB output](https://subversion.le-tex.de/common/pdf2fxl/sample-input/demojam.epub)
directly from the repo. Please note that as of this writing, fixed
layout EPUB3 files are best viewed in Readium or Adobe Digital
Editions 4 if you are on a desktop computer.

You can verify in the readers that the text is actually selectable and
not part of the images.

## Author

[Martin Kraetke](https://twitter.com/mkraetke), le-tex publishing services

(small contributions, such as this page, by [Gerrit Imsieke](https://twitter.com/gimsieke))
