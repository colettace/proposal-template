all: cleanup proposal
	@echo "done"

proposal:
	pdflatex proposal && bibtex proposal && pdflatex proposal && pdflatex proposal

cover-fields-fixture:
	pdflatex -interaction=nonstopmode -halt-on-error tests/cover-fields-fixture.tex

cleanup:
	@rm -f *.mlf* *.mlt* *.mtc* *.out *.nlo *.aux *.log *.toc *.maf *.lof *.lot *.bbl *.blg *.brf

clean: cleanup
	@rm -f *.pdf tests/*.pdf
