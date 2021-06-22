# Rfxi

Rfxi - Rfx Interface - User interfaces and APIs for [Rfx](https://github.com/andyl/rfx).

Rfxi can be used interactively, and can interoperate with standalone processes
like scripts, editors, and dev tools.  Rfxi provides:
- a CLI and a Webapp
- Server APIs via Rest/JSON and Websocket

**Note:** This code is pre-release.  Not yet ready for use!!!

## Roadmap

- [x] CLI: Options parser
- [x] CLI: Mix-like task introspection
- [x] CLI: Repl
- [ ] CLI: with Neovim Plugins using Lua/popen 
- [ ] CLI: BASH Completion File
- [ ] CLI: Command to start server
- [ ] Sample app with custom Rfx Operations
- [ ] Web: End-User pages
- [ ] Web: Restful JSON API
- [ ] Web: WebSockets API

## Notes

About Rfxi:
- The CLI is extensible for new Rfx Operations using an introspection technique
  borrowed from custom Mix Tasks.  
- A standalone app can add custom modules to the `Rfx.Ops` namespace.  Using
  runtime introspection they will be integrated into the CLI help menus just
  like built-in Rfx Operations. 
- There is a repl built into the CLI.
- The repl uses the same option parser as the CLI.  
- The web server can be started from a CLI command (eg `rfx --server`) - similar
  to how it is done with Livebook
- The WebUI will provide an API - Restful JSON & socket interfaces - and have
  Liveviews for lightweight testing and monitoring
- The JSON and socket interfaces will use the same option parser as the CLI

# Related Code

- [Rfx][rfx] and [Sourceror][src] - the foundation libraries for Rfxi
- [RfxiNvim][nvm] - an experimental Neovim plugin that uses Rfxi

[rfx]: https://github.com/andyl/rfx
[nvm]: https://github.com/andyl/rfxi_nvim
[src]: https://github.com/doorgan/sourceror

## Installation

- Clone this repo
- Install the dependencies `mix deps.get`
- Build the escript `mix escript.build`
- Run the script `./rfx --help`

