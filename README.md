# Proposal template

A practical starting point for a government proposal or white paper. The
template provides configurable cover sheets, solicitation presets, optional
cover rows, document-control markings, page styles, document-information and
acronym pages, a compliance-oriented response outline, and BibTeX citations.

> **Before distributing a proposal:** replace `includes/logo.png`; the sample
> image belongs to the OpenBSD project. Replace every sample value and every
> bracketed drafting prompt, and validate all markings against the solicitation.

## Quick start

1. Edit `includes/organization.tex` once with the organization details that
   should carry into future proposals.
2. Copy the repository for a new opportunity, then edit the metadata and body
   in `proposal.tex`.
3. Keep only the cover and information pages the deliverable requires, and
   replace `includes/logo.png` and `includes/acronyms.tex` as needed.
4. Run `make`, review `proposal.pdf`, and run `make validate` before delivery.

For TeX installation, supported engines, Make targets, TeXShop, citations,
validation, and troubleshooting, see [Building the document](BUILDING.md).
Compile `proposal.tex`, not `includes/template.tex`.

## Where to customize

The files have deliberately separate responsibilities:

| Scope | File | Purpose |
| --- | --- | --- |
| Every proposal | `includes/organization.tex` | Organization defaults |
| One opportunity | `proposal.tex` | Metadata and response |
| Template behavior | `includes/template.tex` | Layout and commands |
| Supporting content | `includes/` | Acronyms, sources, and logo |

For a normal proposal, do **not** edit `includes/template.tex`. Change it only
when maintaining a fork whose layout or behavior should apply to every future
proposal. This keeps reusable organization data out of the template internals
and opportunity data together in `proposal.tex`.

### One-time organization setup

Set every value in `includes/organization.tex`:

- `\OrganizationName`, `\OrganizationAddress`, `\OrganizationPhone`, and
  `\OrganizationEmail`;
- `\OrganizationCAGECode` and `\OrganizationUEI`; and
- `\OrganizationDefaultPOC`, the person used as the starting technical,
  contracts, and security contact.

These are defaults, not assertions that the same values suit every
solicitation. Override their use in `proposal.tex` when an opportunity requires
a different contact, address, identifier, or submitting entity.

### Proposal-by-proposal checklist

Work from the top of `proposal.tex` downward:

1. Set the project, title, author, short description, and PDF subject.
2. Select one solicitation preset (`\ProposalPresetRFP`,
   `\ProposalPresetRFQTaskOrder`, `\ProposalPresetBAA`, or
   `\ProposalPresetWhitePaper`), then replace its cover values. A later
   `\renewcommand` can override any preset value or `\ProposalLabel...` label.
3. Review every cover field. Empty namespaced fields suppress their entire row.
   Optional legacy rows (`\companytype`, `\companyref`, `\team`, `\cost`,
   `\awardtype`, `\placeofperformance`, `\pop`, and `\tin`) appear only when
   their `\def` line is present; comment out that line to remove the row.
4. Keep only the required page commands: `\proposalcover`, `\whitepapercover`,
   and `\docinfo`. Commenting out a command removes that page group.
5. Reorder and rename the outline to mirror the solicitation, delete
   inapplicable sections, and replace every bracketed prompt with evidence-based
   proposal content.
6. Add acronyms and sources only when used. To print references, add citations
   and uncomment `\bib` near the end of `proposal.tex`.

#### Contacts: share, change, or remove

The sample assigns `\OrganizationDefaultPOC` and the organization email, phone,
and address to all three contact families:
`\ProposalTechnicalPOC...`, `\ProposalContractsPOC...`, and
`\ProposalSecurityPOC...`.

- **Same person for all roles:** leave those assignments as-is.
- **Different people:** replace the values in the applicable family in
  `proposal.tex`.
- **Remove a contact row:** set its name to empty, for example
  `\renewcommand{\ProposalSecurityPOC}{}`. The row is suppressed even if its
  email, phone, or address assignments remain. Clearing individual detail
  fields removes only those detail lines.

### Document-control markings

Five independent profiles are available and disabled by default: offeror
proprietary data, a solicitation-prescribed legend, CUI, export-controlled
information, and classified material. Each profile requires reviewed values for
`Authority`, `Banner`, `PortionMarking`, `Dissemination`, and `Handling` before
its `...true` switch is enabled; compilation fails if an enabled profile is
incomplete.

| Profile prefix | Enable switch |
| --- | --- |
| `\ProposalOfferorProprietary...` | `\ProposalOfferorProprietarytrue` |
| `\ProposalSolicitationLegend...` | `\ProposalSolicitationLegendtrue` |
| `\ProposalCUI...` | `\ProposalCUItrue` |
| `\ProposalExportControlled...` | `\ProposalExportControlledtrue` |
| `\ProposalClassified...` | `\ProposalClassifiedtrue` |

Configure and enable a profile in `proposal.tex`, after the two `\input` lines
and before `\begin{document}`. Enabled banners appear in headers and footers;
the document-information pages record the full profile.

The repository supplies no authoritative marking language. Obtain exact text
from the solicitation and governing clauses, and confirm it with the
contracting officer and, as applicable, security or export-control officials.
Profiles are not interchangeable, and enabling one does not make an
unauthorized system or workflow suitable for controlled information.

## Repository map

```text
proposal.tex                    Proposal-specific configuration and content
includes/organization.tex       Reusable organization defaults
includes/template.tex           Document implementation and reusable layouts
includes/acronyms.tex           Acronym definitions
includes/refs.bib               BibTeX database
includes/logo.png               Replaceable logo
tests/cover-fields-fixture.tex  Optional-cover-row regression document
Makefile                        Build, validation, and cleanup targets
BUILDING.md                     General LaTeX and build guidance
```
