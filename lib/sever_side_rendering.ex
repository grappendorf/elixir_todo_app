defmodule React do
  def createElementArray tag, attributes, children do
    Phoenix.HTML.Tag.content_tag String.to_atom(tag), children,
      cleanup_attributes(attributes)
  end

  def cleanup_attributes attributes do
    attributes
    |> replace_attribute("className", "class")
    |> delete_attribute("onChange")
    |> delete_attribute("onKeyUp")
    |> delete_attribute("onClick")
    |> to_keyword_list()
  end

  defp replace_attribute attributes, key, new_key, fun \\ &(&1) do
    case Map.get attributes, key do
      nil -> attributes
      value -> attributes
                |> Map.delete(key)
                |> Map.put(new_key, fun.(value))
    end
  end

  defp delete_attribute attributes, key do
    Map.delete attributes, key
  end

  defp to_keyword_list(dict) do
    Enum.map(dict, fn({key, value}) -> {String.to_atom(key), value} end)
  end
end

defmodule JSON do
  def parse(s), do: Poison.decode! s
end

defmodule :document do
  def getElementById("config"), do: %{ innerHTML: "{}" }
  def getElementById("state"), do: %{ innerHTML: "null" }
end

defmodule :console do
  def log(val), do: IO.inspect val
end
