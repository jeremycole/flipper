PROJECT=$(TEXINFO_MAIN:%.texi=%)

PHONY_TARGETS=\
	all \
	clean \
	reallyclean \
	publish \
	images \
	pdf_images \
	png_images \
	html_images \
	pdf \
	html \
	html_onefile \
	html_manyfiles \
	$(NULL)

.PHONY: $(PHONY_TARGETS) 

all: pdf html

clean:
	rm -rf html *.recent *.html *.pdf *~

reallyclean: clean
	rm -rf $(GRAFFLE_SOURCES:%.graffle=%.png)
	rm -rf $(GRAFFLE_SOURCES:%.graffle=%.pdf)

%.png: %.graffle
	osascript support/graffle-export.applescript "PNG" `pwd`/$< `pwd`/$@

%.pdf: %.graffle
	osascript support/graffle-export.applescript "Apple PDF pasteboard type" `pwd`/$< `pwd`/$@

publish: all
	publish-docs flipper

images: png_images pdf_images

png_images: png_images.recent
png_images.recent: $(GRAFFLE_SOURCES) $(GRAFFLE_SOURCES:%.graffle=%.png)
	touch $@

pdf_images: pdf_images.recent
pdf_images.recent: $(GRAFFLE_SOURCES) $(GRAFFLE_SOURCES:%.graffle=%.pdf)
	touch $@

pdf: pdf_images $(TEXINFO_MAIN:%.texi=%.pdf)
%.pdf: %.texi $(TEXINFO_SOURCES)
	cp $< $(PROJECT)-tmp.texi
	pdftex --interaction=nonstopmode $(PROJECT)-tmp.texi
	texindex $(PROJECT)-tmp.??
	pdftex --interaction=nonstopmode $(PROJECT)-tmp.texi
	texindex $(PROJECT)-tmp.??
	pdftex --interaction=nonstopmode $(PROJECT)-tmp.texi
	mv $(PROJECT)-tmp.pdf $@
	rm -f $(PROJECT)-tmp.*
	touch $@

html: html_onefile html_manyfiles

html_images: html_images.recent
html_images.recent: png_images.recent
	mkdir -p html/images/
	rsync -avW --exclude "*.pdf" --exclude "*.graffle" --exclude ".svn" --exclude ".DS_Store" $(IMAGE_DIRS) html/images/
	touch html_images.recent

html_onefile: html_images.recent html_onefile.recent
html_onefile.recent: $(TEXINFO_MAIN) $(TEXINFO_SOURCES)
	support/texi2html --init-file=support/provenscaling.init --output html/$(PROJECT)_onefile.html $<
	touch html_onefile.recent

html_manyfiles: html_images.recent html_manyfiles.recent
html_manyfiles.recent: $(TEXINFO_MAIN) $(TEXINFO_SOURCES)
	mkdir -p html
	support/texi2html --init-file=support/provenscaling.init --split node --node-files --subdir=html --top-file=index.html $<
	touch html_manyfiles.recent
