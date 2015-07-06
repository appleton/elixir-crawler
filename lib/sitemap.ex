defmodule SiteMap do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def has_page?(name) do
    Agent.get __MODULE__, fn map ->
      Dict.has_key?(map, name)
    end
  end

  def put_page(name, links) do
    IO.puts "Saving links for " <> name

    Agent.update __MODULE__, fn map ->
      Map.put(map, name, links)
    end
  end

  def to_json do
    Agent.get __MODULE__, fn map ->
      {:ok, json} = JSON.encode(map)
      json
    end
  end
end
