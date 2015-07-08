defmodule Crawler do
  def main(args) do
    args |> parse_args |> crawl
  end

  def crawl(url) do
    HTTPotion.start
    SiteMap.start_link

    get_all(url, [url])

    # TODO: does this need to wait?
    IO.puts SiteMap.to_json
  end

  def get_all(_, []) do
    {:ok}
  end

  def get_all(base, stack) do
    Enum.each stack, fn url ->
      task = Task.async(fn -> get(base, url) end)
      Task.await(task, 10_000)
    end
  end

  def get(base, url) do
    # TODO: each fetch should be in a new process
    IO.puts "getting " <> url

    SiteMap.put_page(url, [])
    %{body: body} = HTTPotion.get(url)
    links = Parser.parse(base, body)
    SiteMap.put_page(url, links)

    to_fetch = Enum.filter links, fn link ->
      !SiteMap.has_page?(link)
    end

    get_all(base, to_fetch)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [url: :string])
    options[:url]
  end
end
