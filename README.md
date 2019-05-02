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

The other prerequisites are Java 1.7 (or newer) and bash.

## Clone the repository

It's necessary to clone the repository with the `--recursive` option
to include the Git submodules.

```
git clone http://github.com/transpect/pdf2fxl --recursive
```

## Invocation

`./pdf2fxl sample/demojam.pdf -d -e`

pdf2fxl <options> {PDF}

| switch |  options                |
|--------|-------------------------|
| -z     | zoom factor             |
| -o     | custom output directory |
| -r     | raster text as image    |
| -e     | create epub             |
| -p     | omit poppler            |
| -d     | turn debug mode on      |

