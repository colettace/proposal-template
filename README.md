# Proposal template

This repository is a starting point for a LaTeX proposal or white paper. It
includes a configurable government-proposal cover sheet, ordinary and
restricted page styles, a document-information page, an acronym list, and a
traditional BibTeX bibliography.

> **Logo notice:** `includes/logo.png` belongs to the OpenBSD project. Replace
> it with your organization's logo before distributing your document.

## Start here

LaTeX turns plain-text `.tex` source files into a PDF. This project uses
[`latexmk`](https://ctan.org/pkg/latexmk) to run LaTeX as many times as needed
and uses traditional BibTeX—not `biblatex` or Biber—for citations.

1. Install a TeX distribution. On macOS, install
   [MacTeX](https://www.tug.org/mactex/); on Linux, install your distribution's
   TeX Live packages. Make sure `latexmk`, `pdflatex`, and `bibtex` are present.
   The template also requires the Latin Modern fonts and the `fontenc`,
   `microtype`, `enumitem`, `xcolor`, `hyperref`, and `bookmark` packages (a
   full TeX Live or MacTeX installation includes them).
2. Clone or download this repository and open a terminal in its top-level
   directory (the directory containing `Makefile`).
3. Edit the metadata and sample prose in `proposal.tex`.
4. Replace `includes/logo.png` and edit bibliography records in
   `includes/refs.bib`.
5. Run `make`. The finished document is `proposal.pdf`.
6. Run `make validate` before sharing the PDF.

Do not compile `includes/template.tex` directly. It supplies the document
class, packages, page designs, and helper commands; `proposal.tex` is the main
document.

### Supported TeX engines

**pdfLaTeX is the default and recommended engine** used by every Make target.
It uses T1 font encoding and the maintained Latin Modern Type 1 fonts. The
template also supports **LuaLaTeX** through `fontspec`, using the Latin Modern
Roman, Sans, and Mono OpenType fonts shipped with TeX Live's Latin Modern
package. Other engines intentionally produce an error rather than silently
selecting a different font setup.

To make a one-off LuaLaTeX build, run:

```sh
latexmk -lualatex -bibtex -interaction=nonstopmode -halt-on-error -file-line-error proposal.tex
```

Whichever engine you choose, use it consistently for a build; clean generated
files before switching engines. Traditional BibTeX remains the bibliography
processor for both engines.

## Build commands

| Command | Purpose |
| --- | --- |
| `make` or `make proposal` | Build `proposal.pdf` with `latexmk` (recommended). |
| `make manual` | Run the explicit LaTeX/BibTeX four-pass sequence. |
| `make debug` | Alias for `make manual`. |
| `make validate` | Build and check the main PDF, citations, cross-references, and cover fixture. |
| `make cover-fields-fixture` | Build the optional-cover-field regression fixture. |
| `make cleanup` | Delete intermediate files but keep generated PDFs. |
| `make clean` | Delete intermediate files and generated PDFs. |

`latexmk` is the primary build orchestrator because it notices which generated
files changed and repeats tools until the document settles. The manual target
is intentionally kept for learning and diagnosis. It performs exactly:

```sh
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error proposal.tex
bibtex proposal
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error proposal.tex
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error proposal.tex
```

Run those commands from the repository root. If one fails, read the last error
in `proposal.log`, fix the source, and rerun the complete sequence. `make
cleanup` is useful when generated state appears stale; use `make clean` only
when you also want to remove the PDFs.

## macOS, MacTeX, and TeXShop

### Command line with MacTeX

MacTeX installs the required programs under `/Library/TeX/texbin`. A new
Terminal window normally finds them automatically. Check with:

```sh
latexmk -v
pdflatex --version
bibtex --version
```

Then change to this repository and run `make`. If the commands are not found,
add `/Library/TeX/texbin` to your shell's `PATH` or reopen Terminal after the
MacTeX installation.

### TeXShop

Open `proposal.tex`, not `includes/template.tex`. For the simplest workflow,
choose **LaTeXmk** in TeXShop's Typeset engine menu and click **Typeset**. If
LaTeXmk is not listed, use TeXShop's engine preferences or run `make` in
Terminal.

To reproduce the manual workflow inside TeXShop, typeset once with **LaTeX**,
switch the engine to **BibTeX** and typeset, then switch back to **LaTeX** and
typeset twice. The engine names may appear as `pdfLaTeX` and `BibTeX` depending
on the TeXShop version. Terminal remains the authoritative way to run the
repository's validation targets.

## Configure the document

The first part of `proposal.tex` contains sample metadata. Commands beginning
with `\Proposal` are declared by the template and must be configured with
`\renewcommand`:

```tex
\renewcommand{\ProposalProjectName}{Project Name}
\renewcommand{\ProposalTitle}{A Descriptive Proposal Title}
\renewcommand{\ProposalCompany}{Company Name}
\renewcommand{\ProposalAuthor}{Author Name}
\renewcommand{\ProposalSubject}{Technical proposal for Project Name}
```

These values populate both the document and its PDF title, author, and subject
metadata. Set them before `\begin{document}`.

Choose a solicitation preset before setting solicitation-specific values:

```tex
\ProposalPresetRFP % or \ProposalPresetRFQTaskOrder, \ProposalPresetBAA,
                   % or \ProposalPresetWhitePaper
\renewcommand{\ProposalSolicitationNumber}{RFP-2026-001}
```

Presets supply appropriate procurement-type values and common labels. They do
not lock the cover: every value and every `\ProposalLabel...` command may be
overridden with `\renewcommand` after applying the preset.

The configurable cover metadata includes solicitation number, amendment
acknowledgment, opportunity title, agency, office, procurement type, proposal
volume and number, submission date/time zone, NAICS, size status, contract
vehicle/task order, set-aside, CAGE, UEI, and validity period. Empty values
suppress their rows. `\ProposalBAATechnicalArea` and
`\ProposalBAATopicNumber` are optional even under the BAA preset rather than
being assumed for every submission. Configure distinct contacts with the
`\ProposalTechnicalPOC...`, `\ProposalContractsPOC...`, and
`\ProposalSecurityPOC...` command families; each supports a name, email,
phone, and address.

Additional legacy fields use the existing `\def` style. The following cover
rows are optional and disappear when their command is not defined:

- `\companytype`, `\companyref`, and `\team`
- `\cost` and `\awardtype`
- `\placeofperformance` and `\pop`
- `\tin`

Choose the pages appropriate to the deliverable near
`\begin{document}`:

- `\proposalcover` creates the government-proposal cover.
- `\whitepapercover` creates a general title page.
- `\docinfo` creates copyright, contact, contents, figure, table, and acronym
  pages.

Remove or comment out a command for a page you do not need. Customize acronyms
in `includes/acronyms.tex`.

### Document-control marking profiles

The template provides five independent profiles, all disabled by default:

| Profile | Enable switch | Configuration prefix |
| --- | --- | --- |
| Offeror proprietary data | `\ProposalOfferorProprietarytrue` | `\ProposalOfferorProprietary...` |
| Solicitation-prescribed proposal legend | `\ProposalSolicitationLegendtrue` | `\ProposalSolicitationLegend...` |
| Controlled Unclassified Information (CUI) | `\ProposalCUItrue` | `\ProposalCUI...` |
| Export-controlled information | `\ProposalExportControlledtrue` | `\ProposalExportControlled...` |
| Classified material | `\ProposalClassifiedtrue` | `\ProposalClassified...` |

Each prefix has `Authority`, `Banner`, `PortionMarking`, `Dissemination`, and
`Handling` commands. Every one must be set to a nonempty, reviewed value before
its switch is enabled; compilation deliberately fails otherwise. If portion
marking or dissemination restrictions do not apply, record that reviewed
determination explicitly rather than leaving the field empty. Enabled banners
appear in page headers and footers, and the document-information page records
the complete profile details.

The repository supplies no authoritative legend, classification, CUI,
export-control, or data-rights wording. Before enabling any profile, consult
the actual solicitation and applicable contract clauses and confirm the text
and treatment with the contracting officer. Consult the security officer for
CUI or classified material and the export-control officer for controlled
technical data. The responsible officials—not this template—must determine
whether markings apply, which authority governs, the exact banner and portion
marks, permitted dissemination, and handling requirements.

For example, configuration follows this shape, using values obtained from
those sources rather than copied universal text:

```tex
\renewcommand{\ProposalOfferorProprietaryAuthority}{<governing clause or solicitation section>}
\renewcommand{\ProposalOfferorProprietaryBanner}{<exact approved banner text>}
\renewcommand{\ProposalOfferorProprietaryPortionMarking}{<required behavior or reviewed not-applicable determination>}
\renewcommand{\ProposalOfferorProprietaryDissemination}{<approved dissemination controls>}
\renewcommand{\ProposalOfferorProprietaryHandling}{<approved handling notes>}
\ProposalOfferorProprietarytrue
```

Do not treat profiles as interchangeable. In particular, changing a banner
string cannot turn a proprietary proposal into a classified document;
classified material requires its separately reviewed profile and authorized
systems, facilities, personnel, and procedures.

## Citations and the BibTeX lifecycle

The citation architecture is deliberately traditional:

1. Add an entry with a unique key to `includes/refs.bib`, for example
   `@article{smith2026example, ...}`.
2. Cite that key in `proposal.tex` with `\cite{smith2026example}`.
3. The first `pdflatex` pass writes citation requests and bibliography metadata
   to `proposal.aux`. Seeing question marks in this first-pass PDF is normal.
4. `bibtex proposal` reads `proposal.aux`, finds the requested entries in
   `includes/refs.bib`, applies the `unsrt` style, and writes `proposal.bbl`.
5. The next `pdflatex` pass reads `proposal.bbl`, inserts the bibliography, and
   writes updated labels and page references.
6. The final `pdflatex` pass resolves the remaining citation numbers,
   cross-references, table of contents, and hyperlink back-references.

The `\bib` command near the end of `proposal.tex` is what selects the `unsrt`
style and the `includes/refs` database. Keep it before `\end{document}`. Do not
run `bibtex proposal.tex`; BibTeX takes the job name, so the correct command is
`bibtex proposal`. In everyday work, simply run `make` and let `latexmk` decide
which passes are necessary.

## Validation

`make validate` performs four checks:

- **Main document:** `proposal.pdf` exists and is nonempty after a successful
  `latexmk` build.
- **Citations:** `proposal.log` and `proposal.blg` contain no unresolved
  citation or missing-database-entry warnings.
- **References:** `proposal.log` contains no unresolved cross-reference or
  unsettled-label warning.
- **Cover fixture:** `tests/cover-fields-fixture.tex` compiles and produces a
  nonempty PDF. The fixture renders all optional cover rows, then renders them
  all omitted, guarding both layouts.

Because validation examines generated log files, do not delete intermediates
between the build and individual validation targets. The combined `make
validate` target manages the order for you.

## Troubleshooting

### `latexmk`, `pdflatex`, or `bibtex` is not found

Install a complete TeX distribution and open a new terminal. On macOS, verify
that `/Library/TeX/texbin` is on `PATH`. Minimal Linux installations may need
extra packages for `acronym`, `bookmark`, `csquotes`, `enumitem`, `lmodern`,
`microtype`, or `titlesec`.

### The PDF shows `[?]`, `??`, or no bibliography

Confirm that every `\cite{key}` exactly matches an entry in
`includes/refs.bib`, that `\bib` remains in the document, and that BibTeX is
being run on `proposal` rather than on a file path or `.tex` filename. Run
`make cleanup && make validate` to rebuild the generated dependency chain.
Inspect `proposal.blg` for BibTeX diagnostics.

### LaTeX says a control sequence is undefined

Check spelling and ensure metadata appears after
`\input{includes/template.tex}`. Use `\renewcommand` for the namespaced
`\Proposal...` commands and retain the documented `\def` form for legacy
fields. Compile from the repository root so relative `includes/...` paths work.

### LaTeX stops with a package or file error

The first error is usually the useful one. Search `proposal.log` for lines
beginning with `!` or use `make manual` to see exactly which stage fails. A
missing `.sty` file means the corresponding TeX package must be installed.

### Changes do not appear or the build loops

Run `make cleanup` and rebuild. This removes auxiliary state while preserving
the last PDF. Persistent rerun or undefined-reference warnings indicate a real
source problem; `make validate` intentionally fails until it is corrected.

## Repository architecture

```text
proposal.tex                    Main document and proposal-specific metadata
includes/template.tex           Document class, packages, covers, and helpers
includes/refs.bib               Traditional BibTeX database
includes/acronyms.tex           Acronym definitions
includes/logo.png               Replaceable cover logo
tests/cover-fields-fixture.tex  Optional-cover-row regression document
Makefile                        Build, validation, and cleanup entry points
```

Keep reusable layout behavior in `includes/template.tex` and proposal content
in `proposal.tex`. Keep bibliography data in `includes/refs.bib`; generated
`.aux`, `.bbl`, `.blg`, `.log`, and PDF files should not be edited by hand.
