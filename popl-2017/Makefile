PAPER=paper

all: ${PAPER}.pdf

compiled/pearl_scrbl.zo: *.rkt *.scrbl
	raco make -v $(PAPER).scrbl

${PAPER}.pdf: pkg setup texstyle.tex
	scribble ++extra fig-stlc-surface.tex \
           ++extra fig-stlc-core.tex \
           ++extra fig-elab0.tex \
           ++extra fig-elab1.tex \
           ++extra fig-elab-regexp.tex \
           ++extra fig-elab-sigma.tex \
           ++extra fig-regexp-lib.tex \
           ++extra fig-stlc-dict.tex \
           ++extra mathpartir.sty \
           ++style texstyle.tex \
           --pdf $(PAPER).scrbl

${PAPER}.tex: pkg setup texstyle.tex
	scribble ++style texstyle.tex --latex $(PAPER).scrbl

pkg:
	raco pkg install --skip-installed trivial

setup:
	raco make ${PAPER}.scrbl

clean:
	rm -r compiled

