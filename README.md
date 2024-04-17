![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog/TL-Verilog Project Template for FPGA Demo Board

## Overview

This project provides a template for generating an FPGA bitstream for the TT03 Demo Board for a Verilog or TL-Verilog based design for Tiny Tapeout.

## Project

A project derived from this template would be documented [here](docs/info.md).

## What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Verilog Project Setup

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Optionally, add a testbench to the `test` folder. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/).

## Makerchip and/or TL-Verilog Projects

Makerchip is an online IDE for digital circuit design supporting Verilog or TL-Verilog projects. This starting template provides a virtual environment for Tiny Tapeout simulations.

- [starting template](https://www.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2Ftt06-verilog-template%2Fmain%2F/src/tt_um_template.tlv) (Ctrl-click for new tab) 
- [calculator circuit example](https://www.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2Fmakerchip_examples%2Fmain%2Ftiny_tapeout_examples%2Ftt_um_calculator.tlv#) (Ctrl-click for new tab)

![tt_template_makerchip](https://github.com/stevehoover/tt05-verilog-demo/assets/11302288/37f65ea1-6898-41ac-a5b1-c9afb7b824f1)

This environment has been used in the course "ChipCraft: The Art of Chip Design". Course materials and student projects can be found in the [course repo](https://github.com/efabless/chipcraft---mest-course).

### Makerchip/TL-Verilog Project Setup

To use Makerchip and TL-Verilog for your project:

1. Create your top-level Makerchip-compatible `.tlv` (TL-Verilog or Verilog) source file as a copy of this [https://raw.githubusercontent.com/stevehoover/tt06-verilog-template/main/src/tt_um_template.tlv](tt_um_template.tlv) file.
1. In this new file, specify your module name as `tt_um_<github-username>_<project-name>` using the settings at the top of the file.
1. As you would for Verilog projects (above), edit `info.yaml`, `docs/info.md`, `src/Makefile`, and `tb.v`. For `.tlv` sources, these would reference the generated `.v` files, not the `.tlv` source.
1. Add the generated `src/*.v` to `.gitignore` to avoid committing it/them.

> [!NOTE]
> In case of local build errors, note that the `Makefile` uses the cocotb Makefile which messes with the Python environment and
> can break the SandPiper(TM) command that compiles the `.tlv` code. If you encounter Python environment errors, look for
> the SandPiper command in the `make` output, and run it manually. Then run `make` (as a pre-check for testing via GitHub).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://docs.google.com/document/d/1aUUZ1jthRpg4QURIIyzlOaPWlmQzr-jBn3wZipVUPt4)

## What next?

- Review/complete [your project documentation](docs/info.md) that explains your design, how it works, and how to test it.
- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@matthewvenn](https://twitter.com/matthewvenn)
