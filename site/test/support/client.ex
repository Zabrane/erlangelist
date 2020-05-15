defmodule ErlangelistTest.Client do
  require Phoenix.ConnTest
  @endpoint ErlangelistWeb.Blog.Endpoint

  def get(path, opts \\ []) do
    uri =
      path
      |> URI.parse()
      |> Map.update!(:host, &(&1 || "localhost"))
      |> Map.update!(:scheme, &(&1 || "https"))
      |> URI.to_string()

    set_today(Keyword.get(opts, :accessed_at, Date.utc_today()))
    Phoenix.ConnTest.get(Phoenix.ConnTest.build_conn(), uri)
  end

  def article(id, opts \\ []) do
    get("/article/#{id}", opts)
  after
    Erlangelist.UsageStats.sync()
  end

  def rss_feed, do: get("/rss")

  def set_today(date) do
    Mox.stub(Erlangelist.Date.Mock, :utc_today, fn -> date end)
    Mox.allow(Erlangelist.Date.Mock, self(), Erlangelist.UsageStats.Server)
    Mox.allow(Erlangelist.Date.Mock, self(), Erlangelist.UsageStats.Cleanup)
  end
end
