LATEXMK ?= latexmk
PDFLATEX ?= pdflatex
BIBTEX ?= bibtex

LATEX_FLAGS := -interaction=nonstopmode -halt-on-error -file-line-error
MAIN := proposal
COVER_FIXTURE := tests/cover-fields-fixture

.DEFAULT_GOAL := all

.PHONY: all proposal manual debug validate validate-main validate-citations \
	validate-references validate-cover cover-fields-fixture cleanup clean

all: proposal
	@echo "Built $(MAIN).pdf"

# latexmk is the normal entry point. -bibtex explicitly retains the traditional
# BibTeX toolchain used by \bibliography and \bibliographystyle in the template.
proposal:
	$(LATEXMK) -pdf -bibtex $(LATEX_FLAGS) $(MAIN).tex

# Transparent four-pass equivalent for debugging: LaTeX, BibTeX, LaTeX, LaTeX.
manual debug:
	$(PDFLATEX) $(LATEX_FLAGS) $(MAIN).tex
	$(BIBTEX) $(MAIN)
	$(PDFLATEX) $(LATEX_FLAGS) $(MAIN).tex
	$(PDFLATEX) $(LATEX_FLAGS) $(MAIN).tex

cover-fields-fixture:
	$(LATEXMK) -pdf $(LATEX_FLAGS) $(COVER_FIXTURE).tex

# Compile both documents first, then turn unresolved cross-references and
# citations into validation failures rather than easy-to-miss log warnings.
validate: validate-main validate-citations validate-references validate-cover
	@echo "All document validations passed"

validate-main: proposal
	@test -s $(MAIN).pdf

validate-citations: proposal
	@! grep -Eiq 'Citation .* undefined|undefined citations|There were undefined citations' $(MAIN).log
	@! grep -Eiq 'Warning--I didn.t find a database entry|I found no \\citation commands' $(MAIN).blg

validate-references: proposal
	@! grep -Eiq 'Reference .* undefined|undefined references|There were undefined references|Label\(s\) may have changed' $(MAIN).log

validate-cover: cover-fields-fixture
	@test -s $(COVER_FIXTURE).pdf

# Remove only generated intermediate files; keep the PDFs for inspection.
cleanup:
	-$(LATEXMK) -c $(MAIN).tex $(COVER_FIXTURE).tex
	@rm -f *.mlf* *.mlt* *.mtc* *.nlo *.maf *.brf tests/*.mlf* tests/*.mlt* tests/*.mtc* tests/*.nlo tests/*.maf tests/*.brf

# Remove intermediates and generated PDFs.
clean:
	-$(LATEXMK) -C $(MAIN).tex $(COVER_FIXTURE).tex
	@rm -f $(MAIN).pdf $(COVER_FIXTURE).pdf
