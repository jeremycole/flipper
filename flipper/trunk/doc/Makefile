
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

all: images html_onefile html_manyfiles pdf 

clean:
	rm -rf html html_manyfiles.recent *.html *.pdf *~
	rm -rf $(GRAFFLE_SOURCES:%.graffle=%.png)

%.png: %.graffle
	osascript support/graffle-to-png.applescript `pwd`/$< `pwd`/$@

images: $(GRAFFLE_SOURCES:%.graffle=%.png)

publish: all
	publish-docs flipper

pdf: images flipper.pdf
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

html_onefile: images flipper.html
flipper.html: $(TEXINFO_SOURCES)
	texi2html flipper.texi

html_manyfiles: images html_manyfiles.recent
html_manyfiles.recent: $(TEXINFO_SOURCES)
	mkdir -p html
	texi2html --init-file=support/provenscaling.init --split node --node-files --subdir=html --top-file=index.html flipper.texi
	touch html_manyfiles.recent
