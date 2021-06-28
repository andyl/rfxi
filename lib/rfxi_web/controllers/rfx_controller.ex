defmodule RfxiWeb.RfxController do
  use RfxiWeb, :controller

  def index(conn, params) do
    argv = Map.fetch!(params, "argv") |> String.replace("\"", "")
    jtxt = RfxCli.Base.main_core(argv)[:json]
    json conn, jtxt
  end
end
