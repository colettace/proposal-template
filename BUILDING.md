# Building the document

This guide contains the general LaTeX, Make, BibTeX, and editor workflow. See
the [README](README.md) for proposal features and customization.

## Requirements and first build

Install a TeX distribution: [MacTeX](https://www.tug.org/mactex/) on macOS or
your distribution's TeX Live packages on Linux. A full installation supplies
`latexmk`, `pdflatex`, `bibtex`, Latin Modern fonts, and the packages used by
the template.

From the repository root, run:

```sh
make
make validate
```

The output is `proposal.pdf`. `latexmk` is the recommended build orchestrator;
it repeats LaTeX and traditional BibTeX passes until generated files settle.

## Build commands

| Command | Purpose |
| --- | --- |
| `make` or `make proposal` | Build the PDF with `latexmk`. |
| `make manual` or `make debug` | Run each TeX/BibTeX pass. |
| `make validate` | Build and run all checks. |
| `make cover-fields-fixture` | Build the cover test fixture. |
| `make cleanup` | Delete intermediate files but keep PDFs. |
| `make clean` | Delete intermediate files and PDFs. |

## Engines

pdfLaTeX is the default. LuaLaTeX is also supported with the Latin Modern
OpenType fonts:

```sh
latexmk -lualatex -bibtex -interaction=nonstopmode \
  -halt-on-error -file-line-error proposal.tex
```

Clean generated files before switching engines. Other engines intentionally
produce an error. Traditional BibTeX is used with either supported engine.

## macOS and TeXShop

MacTeX normally puts its tools in `/Library/TeX/texbin`. Open a new Terminal
window after installation and verify `latexmk -v` if it is not found.

In TeXShop, open `proposal.tex`, select **LaTeXmk** in the Typeset engine menu,
and click **Typeset**. If that engine is unavailable, run `make` in Terminal.
Terminal is the authoritative way to run the repository's validation targets.

## Citations

1. Add a uniquely keyed record to `includes/refs.bib`.
2. Cite it in `proposal.tex` with `\cite{key}`.
3. Uncomment `\bib` near the end of `proposal.tex`.
4. Run `make`; `latexmk` manages the required LaTeX and BibTeX passes.

The first pass may show unresolved citations. If running tools manually, pass
the job name—not a filename—to BibTeX: `bibtex proposal`.

## Validation

`make validate` checks that the main PDF is nonempty, citation and reference
warnings are resolved, and the fixture can render both populated and omitted
optional cover rows. Do not remove intermediates between a build and individual
validation targets; the combined target manages their order.

## Troubleshooting

- **A command is missing:** install a complete TeX distribution and ensure its
  binaries are on `PATH`. Minimal installations may need additional packages.
- **The PDF contains `[?]` or `??`:** check citation keys, enable `\bib`, then
  run `make cleanup && make validate`.
- **A control sequence is undefined:** check spelling, configure metadata after
  the template input, use `\renewcommand` for `\Proposal...` commands, and build
  from the repository root.
- **LaTeX reports a package/file error:** inspect the first `!` error in
  `proposal.log`; install a missing `.sty` package or correct the referenced
  path.
- **Changes do not appear or the build loops:** run `make cleanup` and rebuild.
  Persistent reference warnings indicate a source issue that must be fixed.
