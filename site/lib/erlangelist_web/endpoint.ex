defmodule ErlangelistWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :erlangelist

  plug Plug.Static, at: "/", from: :erlangelist, gzip: false, only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger, log: :debug
  plug SiteEncrypt.AcmeChallenge, ErlangelistWeb.Site

  unless Mix.env() == :test, do: plug(ErlangelistWeb.ForceSSL)

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  plug ErlangelistWeb.MovePermanently, from: "theerlangelist.com", to: "www.theerlangelist.com"

  plug ErlangelistWeb.Router

  def init(_key, phoenix_defaults), do: {:ok, ErlangelistWeb.EndpointConfig.config(phoenix_defaults)}
end
