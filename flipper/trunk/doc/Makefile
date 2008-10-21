
TEXINFO_SOURCES = \
	flipper.texi \
	flipper-overview.texi \
	flipper-quickstart.texi \
	flipper-installation.texi \
	flipper-configuration.texi \
	flipper-usage.texi \
	flipper-applications.texi \
	flipper-bugs.texi \
	flipper-future.texi \
	flipper-platform.texi \
	flipper-configuration-reference.texi \
	flipper-credits.texi \
	flipper-contact.texi \
	flipper-index-vr.texi \
	flipper-index-cp.texi \
	$(NULL)

GRAFFLE_SOURCES=\
	illustrations/architecture.graffle \
	illustrations/architecture-a.graffle \
	illustrations/architecture-b.graffle \
	illustrations/commands/status.graffle \
	# this illustration crashes omnigraffle on export for some reason
	#illustrations/commands/swap-set-fail-disable.graffle \
	$(NULL)

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

pdf: pdf_images flipper.pdf
flipper.pdf: $(TEXINFO_SOURCES)
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

html: html_onefile html_manyfiles

html_images: html_images.recent
html_images.recent: png_images.recent
	mkdir -p html/images/
	rsync -avW --exclude "*.pdf" --exclude "*.graffle" --exclude ".svn" --exclude ".DS_Store" illustrations html/images/
	touch html_images.recent

html_onefile: html_images.recent html_onefile.recent
html_onefile.recent: $(TEXINFO_SOURCES)
	support/texi2html --init-file=support/provenscaling.init --output html/flipper_onefile.html flipper.texi
	touch html_onefile.recent

html_manyfiles: html_images.recent html_manyfiles.recent
html_manyfiles.recent: $(TEXINFO_SOURCES)
	mkdir -p html
	support/texi2html --init-file=support/provenscaling.init --split node --node-files --subdir=html --top-file=index.html flipper.texi
	touch html_manyfiles.recent
