proposal-template
=================

A latex proposal / whitepaper template - including a templated BAA required coversheet

NOTE:  The copyright for logo.png belongs to the OpenBSD project.  You should
replace logo.png with your own logo.


Configuration
-------------

There are numerous items you can configure to build the proposal.

If you plan on building a proposal, use the following:
* \proposalcover: Generate a cover page formatted appropriately for US Government BAA responses.  Various fields at the top of proposal.tex will be generated table when uncommented, and will not be displayed when commented out.

If you plan on building a whitepaper, use the following:
* \whitepapercover: Generate a standard document cover page
* \docinfo: Generate a document information page

The following fields should be filed out if you intend on using proposalcover or whitepapercover:

* \projectname:  NOTE, whatever you name your project, add \xspace to the end of the definition, as to make use in future macros work out correctly
* \company: Your Company Name
* \companyref: Your Company reference (big companies need this)
* \companytype: OTHER SMALL BUSINESS
* \team: Companies you are teaming with (N/A if you are on your own)
* \restrictions: Proprietary Information
* \biline: Short phrase describing the project
* \author: Your Name
* \email: your-email@example.com
* \phone: your phone number
* \address: your company address

The following fields should be filed out if you intend on using proposalcover: 

* \baa: BAA-2013-001
* \techarea: Technical Area 1 (Your mom's tech area)
* \doctitle: Volume I (Technical and Management Proposal)
* \cost: \$1,000,000
* \duns: 111111111
* \cagecode: 222222
* \tin: 33-3333333
* \awardtype: Cost Plus Fixed Fee (CPFF)
* \pop: January 1, 2000 - December 31, 2020 (3 days)
* \submitdate: January 1, 2020
* \placeofperformance: the location where the proposed work will be performed

Each of the cover-specific fields above from `\cost` through
`\placeofperformance`, as well as `\companyref`, `\companytype`, and `\team`,
is optional: omit its definition to omit its row from the cover table. The
compile-time fixture renders all optional rows once and then renders a cover
with all of them omitted; run it with `make cover-fields-fixture`.

Document Controls
-----------------

If you have to restrict release of the document, configure the legend text in
`proposal.tex`, then enable the applicable boolean with one or both of these
commands:

* `\exportcontrolledtrue`: includes the text from `\exportcontrollegend` on the document information page
* `\proposalrestrictedtrue`: includes the text from `\proposalrestrictedlegend` on the proposal cover

Both booleans default to false.  Markings and legend text must be taken from the
solicitation, security classification guide, CUI marking guidance, or applicable
data-rights clause; the template deliberately does not assume that one warning
is appropriate for every solicitation, contract clause, export jurisdiction, or
CUI category.

On pages that have restricted information, set the page style to "restricted", which will add appropriate messages to the header and footer.  Note, if the document is classified, change "Proprietary Information" in the restrictions definition to appropriate classification marker.  Example:

    \pagestyle{restricted}
