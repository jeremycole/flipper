all: html_onefile html_manyfiles pdf


clean:
	rm -rf html *.html *.pdf

publish: all
	publish-docs flipper

pdf: flipper.pdf
flipper.pdf: flipper.texi
	#sed -e 's|@image{[^}]*} *||g' <$< >flipper-tmp.texi
	cp flipper.texi flipper-tmp.texi
	pdftex --interaction=nonstopmode flipper-tmp.texi
	texindex flipper-tmp.??
	pdftex --interaction=nonstopmode flipper-tmp.texi
	texindex flipper-tmp.??
	pdftex --interaction=nonstopmode flipper-tmp.texi
	mv flipper-tmp.pdf $@
	rm -f flipper-tmp.*
	touch $@

html_onefile: flipper.html
flipper.html: flipper.texi
	texi2html flipper.texi

html_manyfiles: flipper.texi
	mkdir -p html
	texi2html --init-file=support/flipper.init --split node --node-files --subdir=html --top-file=index.html flipper.texi
