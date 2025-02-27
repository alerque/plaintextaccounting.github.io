all: html

# Generate html from all md files
# (including README, maybe useful for local preview. $(filter-out README.md, ...) to exclude).
html: $(patsubst %.md,%.html,$(wildcard *.md quickref/*.md)) Makefile

PANDOC=pandoc -f markdown-smart+autolink_bare_uris

# generate html from a md file
%.html: %.md index.tmpl
	$(PANDOC) --template index.tmpl $< -o $@

# regenerate html whenever an md file changes
html-auto:
	ls *.md | entr make html

BROWSE=open
LIVERELOADPORT=8100
LIVERELOAD=livereloadx -p $(LIVERELOADPORT) -s
  #  --exclude '*.html'
  # Exclude html files to avoid reloading browser as every page is generated.
  # A reload happens at the end when the css/js files get copied.

# Auto-regenerate html, and watch changes in a new browser window.
html-watch:
	make html-auto &
	(sleep 1; $(BROWSE) http://localhost:$(LIVERELOADPORT)/) &
	$(LIVERELOAD) .

# regenerate syntax quick reference html from google docs html export
# (it has been manually edited, let's not do this again)
#quickref/index.html:
#	rm -rf quickref/QuickReferencefortheLedger-Likes
#	-mv ~/Desktop/QuickReferencefortheLedger-Likes quickref
#	cp quickref/QuickReferencefortheLedger-Likes/images/* quickref/images
#	cp quickref/QuickReferencefortheLedger-Likes/QuickReferencefortheLedgerLikes.html quickref/index.html
#	perl -p -i -e 's%<style.*</style>%<meta name="viewport" content="width=device-width, initial-scale=1"><link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css"><link rel="stylesheet" href="/css/normalize.css"><link rel="stylesheet" href="/css/skeleton.css"><link rel="stylesheet" href="/css/site.css"><link rel="icon" type="image/png" href="/images/favicon.png"><link href="quickref.css" rel="stylesheet">%' $@
#	perl -p -i -e 's/>/>\n/g' $@
#	perl -p -i -e 's/(<body .*)/\1\n<div class="container">/' $@
#	perl -p -i -e 's/<\/body>/<\/div>\n<\/body>/' $@

# XXX not working
# watch-quickref:
# 	fswatch -l 0.1 -0 ~/Desktop/QuickReferencefortheLedger-Likes/QuickReferencefortheLedgerLikes.html | xargs -0 -n1 -I{} cat #echo make quickref.html

clean:
	rm -f $(patsubst %.md,%.html,$(wildcard *.md))

