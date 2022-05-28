# FCA-encode-usas-tagged-text

# (g)awk scripts that convert USAS tagged text files to .csv files.

# scripts

[encode-usas-horizontally-tagged-text.awk (to process horizontally USAS tagged text)](encode-usas-horizontally-tagged-text.awk)

[encode-usas-vertically-tagged-text.awk (to process vertically USAS tagged text)](encode-usas-vertically-tagged-text.awk)


## usage

Run with a (g)awk by issuing:

`(g)awk -f encode-usas-horizontally-tagged-text.awk SOURCE_FILE > CSV_FILE`

or

`(g)awk -f encode-usas-vertically-tagged-text.awk SOURCE_FILE > CSV_FILE`

where `SOURCE_FILE is the input` and `CSV_FILE` is the output.

Or, alternatively, you can make the script executable by `chmod +x encode-usas-tagged-text-hmode.awk` or `chmod +x encode-usas-tagged-text-vmode.awk` and then,

`./encode-usas-horizontally-tagged-text.awk SOURCE_FILE > CSV_FILE`

or

`./encode-usas-vertially-tagged-text.awk SOURCE_FILE > CSV_FILE`

# converter of vertial mode tagged text to horizontal mode tagged text

[USAS tagging mode converter](convert-usas-vertical-to-horizontal-tags.pl)

# sample usas-tagged-text.txt files

[sample 1 (tagged in horizontal mode)](usas-horizontally-tagged-text-sample1.txt)


# USAS tools

[UCREL Semantic Analysis System (USAS)](https://ucrel.lancs.ac.uk/usas/)

[Online English USAS tagger (runs in horizontal and vertical modes)](http://ucrel-api.lancaster.ac.uk/usas/tagger.html)

# FCA tools

One of the oldest but greatest tool for FCA

[Concept Explorer (original)](http://conexp.sourceforge.net/)

More recent re-implementation of Concept Explorer with advanced visualizations:

[Concept Explorer FX](https://francesco-kriegel.github.io/conexp-fx/)

