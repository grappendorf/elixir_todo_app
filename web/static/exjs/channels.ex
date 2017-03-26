defmodule Channels do
  def dispatchMessage msg do
    action = [String.to_existing_atom(msg.action) | msg.params] |> List.to_tuple
    Store.dispatch action
  end
end
