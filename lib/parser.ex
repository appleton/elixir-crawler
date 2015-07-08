defmodule Parser do
  def parse(base, page_body) do
    page_body |> Floki.find("a") |> Floki.attribute("href") |> Enum.map(fn link ->
      parse_link(link, base)
    end) |> Enum.filter(fn link -> !is_nil(link) end)
  end

  def parse_link(link, base) do
    %{authority: base_authority} = URI.parse(base)

    case URI.parse(link) do
      %{authority: nil} ->
        base <> link
      %{authority: ^base_authority} ->
        link
      true ->
        nil
    end
  end
end
