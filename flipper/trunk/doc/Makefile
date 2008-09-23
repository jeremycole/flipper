# PDF, Portable Document Format
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

