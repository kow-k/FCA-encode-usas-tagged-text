# FCA-encode-usas-tagged-text

# (g)awk scripts that convert USAS tagged text files to .csv files.

# scripts

[encode-usas-tagged-text-in-hmode.awk (to process horizontally USAS tagged text)](encode-usas-tagged-text-in-hmode.awk)

[encode-usas-tagged-text-in-vmode.awk (to process vertically USAS tagged text)](encode-usas-tagged-text-in-vmode.awk)

## usage

Run with a (g)awk by issuing:

`(g)awk encode-usas-tagged-text-in-hmode.awk SOURCE_FILE > CSV_FILE`

or

`(g)awk encode-usas-tagged-text-in-vmode.awk SOURCE_FILE > CSV_FILE`

where `SOURCE_FILE is the input` and `CSV_FILE` is the output.

Or, alternatively, you can make the script executable by `chmod +x encode-usas-tagged-text-in-hmode.awk` or `chmod +x encode-usas-tagged-text-in-vmode.awk` and then,

`./encode-usas-tagged-text-in-hmode.awk SOURCE_FILE > CSV_FILE`

or

`./encode-usas-tagged-text-in-vmode.awk SOURCE_FILE > CSV_FILE`

# sample usas-tagged-text.txt files

[sample 1](usas-tagged-text-sample1.txt)

# USAS tools

[UCREL Semantic Analysis System (USAS)](https://ucrel.lancs.ac.uk/usas/)

[Online English USAS tagger (runs in horizontal and vertical modes)](http://ucrel-api.lancaster.ac.uk/usas/tagger.html)

# FCA tools

One of the oldest but greatest tool for FCA

[Concept Explorer (original)](http://conexp.sourceforge.net/)

More recent re-implementation of Concept Explorer with advanced visualizations:

[Concept Explorer FX](https://francesco-kriegel.github.io/conexp-fx/)

