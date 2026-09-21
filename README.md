# Vim-completion

> Live completions from a server, without LSP

This repository is an alternative to mainstream LSPs for Vim.

## The problem with LSP

There are two components to an LSP:
1. the protocol between the server and the editor
2. the background work the server performs

Conventionally, both are over complicated.

The LSP protocol is defined by
[Microsoft](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.18/specification/).
That alone should be enough reason to be concerned, but it gets worse.
Its JSON with HTTP headers.
Both of these are clearly off-the-shelf components
that presumably has been choosen to roll out a prototype quickly.
HTTP headers are total overkill, but they work, whatever.
JSON on the otherhand has the main selling point that its flexible
and allows for eventual correctness.
Those are the exact properties you don't want in your standard.
If the data changes, both the server and the client must change,
making the life-cycle of client plugins a nightmare.

> [!CAUTION]
> Unsurprisingly protocol spec comes out at roughly 50'000 words!

## Installation

Requirements:
* Tcl
* Tcl-thread
* Tcl-unix-sockets
