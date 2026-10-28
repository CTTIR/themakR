# Package branding

CTTIR Coder Edition v5, supplied 25 October 2026. Editable native R geometry
and `design_tokens.csv` define the artwork, topic colours and typography.
Every identity has an artwork-only hex and a named composition with the exact
package name inside the hex, each in light, dark and grayscale modes.

Both master compositions are 1600 by 1848 pixels. The approved exports
come from the hexmakR 0.2.0 library. Standard PNG, SVG and PDF masters are
copied unchanged so their font outlines and file hashes stay authoritative.

Render into a separate review directory from the repository root:

```sh
Rscript tools/branding/render.R /path/to/review
```

Regenerate and replace the registered repository assets:

```sh
Rscript tools/branding/render.R --apply
```

`packages.csv` selects the identities; `assets.csv` maps the exported filenames
to their repository destinations. Both the canonical package `logo` and
`logo-with-name` use the named composition for navigation, README images,
vignettes and static package figures. The package name stays inside the hex.
`-dark` and `-mono` select alternate surfaces. Explicit symbols and icons use
artwork-only variants; the maskable icon includes its opaque safe area.

Exporting approved masters requires hexmakR 0.2.0 or later only while running
`tools/branding/render.R`; it adds no runtime dependency to themakR. Standard
masters need no fonts installed because their lettering is already outlined.
Extra platform icon sizes use the bundled base-R motif renderer. Font
licences remain in `fonts/OFL.txt` and `fonts/JetBrainsMono-OFL.txt`.

The shared themakR template uses the named standard logo aliases on every
pkgdown page. Every standalone vignette also carries a scoped light/dark
image block and exact named SVGs in `vignettes/figures/`. Installing a package
does not change the user's fonts or documentation theme.

Regenerate the shared theme token stylesheet into a review directory:

```sh
Rscript tools/branding/render-theme.R /path/to/review
```

To update only `inst/pkgdown/_cttir-tokens.scss` in this repository:

```sh
Rscript tools/branding/render-theme.R --apply
```

This entrypoint loads the local `design_tokens.csv`, token helpers and palette,
then runs the supplied `write_integration.R` generator in temporary staging.
Only `_cttir-tokens.scss` is retained; the generator's standalone font copies
are removed with its staging directory. It does not render artwork or change
the component stylesheet, global theme settings or runtime dependencies.

After building pkgdown, synchronize the current branding in its output:

```sh
Rscript tools/branding/sync-site.R docs
```

This refreshes branding images and the web manifest at the output root and
its existing `dev/` directory. Every HTML page receives browser-tab, touch-icon
and manifest links relative to its own directory, including nested articles.
The links include an artwork revision so browsers refresh changed icons.
Only icon declarations in the page head change; article content and examples
are preserved. Symbolic links in the output tree are rejected. The pkgdown
workflow runs this step before deployment.

Source archive SHA-256:
`420401d00ab4c5eefdd74440d826b76282f3c1e5262c1f044fc0c6a052f6890e`

## Approved v5 masters

`render.R` requires hexmakR 0.2.0 or later. The supplied library is the
authority for the named hex, artwork-only hex and five standard icon sizes.
These files are copied without regenerating font outlines. Additional platform
icon sizes continue to use the bundled R motif renderer. `assets.csv` records
the intended variant for each destination; display logos use `lockup`, while
favicons and explicitly compact symbols use artwork-only variants.
