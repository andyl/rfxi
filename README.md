# Rfxi

Rfx Interface - User interfaces and APIs for [Rfx](https://github.com/andyl/rfx).

Rfxi can be used interactively, and can interoperate with standalone processes:
scripts, editors, dev tools, etc.

This application has:
- a CLI and a Web-server
- Server APIs: Restful JSON, Websocket

**Note:** This code is pre-release.  Not yet ready for use!!!

## Roadmap

- [x] CLI: Options parser
- [x] CLI: Mix-like task introspection
- [x] CLI: Repl
- [ ] CLI: with Neovim Plugins using Lua/popen (fail)
- [ ] CLI: BASH Completion File
- [ ] CLI: Command to start server
- [ ] Document how to extend with custom Rfx Operations
- [ ] Web: End-User pages
- [ ] Web: Restful JSON API
- [ ] Web: WebSockets API

## Notes

About Rfxi:
- The CLI is extensible for new Rfx Operations in a way that is comparable to
  Mix Tasks.  
- A standalone app can add custom modules to the `Rfx.Ops` namespace.  Using
  runtime introspection they will be integrated into the CLI help menus just
  like built-in Rfx Operations. 
- There is a repl built into the CLI.
- The repl uses the same option parser as the CLI.  
- The web server can be started from a CLI command (eg `rfx server`) - similar
  to how it is done with Livebook
- The WebUI will provide an API - Restful JSON & socket interfaces - and have
  some HTML views for lightweight testing and monitoring
- The JSON and socket interfaces will use the same option parser as the CLI

So besides interactive use, Rfxi will provide options to integrate Rfx with
standalone processes:
- command line pipes and redirects
- process integration using popen and popen3
- Restful HTTP API
- Sockets

# Related Code

- Sourceror
- Rfx
- RfxNvim

## Installation

- Clone the repo
- Install the dependencies `mix deps.get`
- Build the escript `mix escript.build`
- Run the script `./rfx --help`
