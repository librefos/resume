#!/bin/sh

set -e

mkdir -p build
for file in resume-br.tex resume-en.tex; do
  xelatex -interaction=nonstopmode -halt-on-error -output-directory=build "$file"
  xelatex -interaction=nonstopmode -halt-on-error -output-directory=build "$file"
done
