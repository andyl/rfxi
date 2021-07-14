# Rfxi

Rfxi / Rfx Interface - User interface and APIs for [Rfx](https://github.com/andyl/rfx).

Rfxi can be used interactively, and can interoperate with standalone apps,
editors, and dev tools.  

Rfxi provides:

- a CLI and a Webapp
- Server APIs via Popen3, Rest/JSON and Websocket

**Note:** This code is pre-release!  Not at all ready for production use.

## Roadmap

- [x] CLI: Options parser
- [x] CLI: Mix-like task introspection on operations and converters
- [x] CLI: Repl
- [x] CLI: Embedded web server
- [x] Web: Restful JSON API
- [x] Web: WebSockets API
- [x] Web: Minimal End-User LiveView pages
- [ ] Neovim: Plugin using JSON/REST interface

## Notes

About Rfxi:
- The CLI is extensible for new Rfx Operations using an introspection technique
  borrowed from custom Mix Tasks.  
- A standalone app can add custom modules to the `Rfx.Ops` namespace.  Using
  runtime introspection they will be integrated into the CLI help menus just
  like built-in Rfx Operations. 
- There is a repl built into the CLI.
- The repl uses the same option parser as the CLI.  
- The web server can be started from a CLI command (eg `rfx --server`), and can
  be launched by a parent process (eg Vim, Emacs, VsCode...)
- The WebUI provides an API - Restful JSON & socket interfaces - and have
  Liveviews for lightweight testing and monitoring
- The JSON and socket APIs use the same option parser and return values as the
  CLI

# Related Code

- [Rfx][rfx] and [Sourceror][src] - the foundation libraries for Rfxi
- [rfx.nvim][nvm] - an experimental Neovim plugin that uses Rfxi
- [rfx.vscode][vsc] - an experimental Vscode extension that uses Rfxi

[rfx]: https://github.com/andyl/rfx
[nvm]: https://github.com/andyl/rfx.nvim
[vsc]: https://github.com/andyl/rfx.vscode
[src]: https://github.com/doorgan/sourceror

## Support

To ask questions:
- use the [issue tracker][trk]
- use the [#refactoring channel][slk] on Elixir Slack

[trk]: https://github.com/andyl/rfxi/issues
[slk]: https://app.slack.com/client/T03EPRA2X/C026XK7QF60/thread/C068BRD62-1613670248.042000

Developers welcome!

## Installation

- Clone this repo
- Install the dependencies `mix deps.get`
- Build the escript `mix escript.build`
- Run the script `./rfx --help`

