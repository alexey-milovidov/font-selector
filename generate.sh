#!/bin/bash

> fonts.css
> fonts.json5lines

for i in fonts/*; do 
    regular=$(find $i -name '*.ttf' -or -name '*.otf' -or -name '*.woff' -or -name '*.woff2' | grep -viP 'bold|italic|black|light|oblique|medium' | awk '{ if (($0 ~ /Regular/) || ($0 ~ /regular/)) { print 0 " " $0 } else { print length($0) " " $0 } }' | sort -n | cut -d ' ' -f 2- | head -n1)
    bold=$(find $i -name '*.ttf' -or -name '*.otf' -or -name '*.woff' -or -name '*.woff2' | grep -i 'bold' | grep -viP 'italic|black|light|oblique|medium' | awk '{ print length($0) " " $0 }' | sort -n | cut -d ' ' -f 2- | head -n1)

    name=$(fc-scan --format "%{family}\n" "$regular" | tr ',' '\n' | head -n1)

    [[ -n "$regular" ]] && echo "@font-face { font-family: '$name'; font-weight: normal; font-style: normal; src: url('$regular'); }" >> fonts.css
    [[ -n "$bold" ]] && echo "@font-face { font-family: '$name'; font-weight: bold; font-style: normal; src: url('$bold'); }" >> fonts.css

#    description=$(
#        (
#            for txt in source.txt readme; do find $i -iname "${txt}*" | xargs cat; done
#            echo
#            find $i -iname 'license*' | xargs sed -r -e '/PREAMBLE|TERMS AND CONDITIONS|Preamble/q'
#        ) | sed -E ':a; N; $!ba; s/\r{0,1}\n/\\n/g; s/'"'"'/\\'"'"'/g;')

    echo "{name: '$name', description: '$description'}," >> fonts.json5lines
done
