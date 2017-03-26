defmodule Todo do
  defstruct id: nil, text: "", status: :todo

  @todo :todo
  @done :done

  def new id, text, status \\ :todo do
    %{id: id, text: text,
      status: (if is_atom(status), do: status, else: String.to_existing_atom status)}
  end

  def new_from_json json do
    %{id: json.id, text: json.text, status: String.to_existing_atom(json.status)}
  end

  def toggle todo = %{status: :todo} do
    %{todo | status: :done}
  end

  def toggle todo = %{status: :done} do
    %{todo | status: :todo}
  end

  def delete todos, id do
    case find_index_by_id todos, id do
      nil -> todos
      index -> List.delete_at(todos, index)
     end
  end

  def update todos, id, fun do
    case find_index_by_id todos, id do
      nil -> todos
      index -> List.update_at todos, index, fun
    end
  end

  def toggle todos, id do
    case find_index_by_id todos, id do
      nil -> todos
      index -> List.update_at todos, index, fn todo -> Todo.toggle(todo) end
    end
  end

  def find_by_id [], id do
    nil
  end

  def find_by_id [todo], id do
    if todo.id == id, do: todo, else: nil
  end

  def find_by_id [todo | rest], id do
    if todo.id == id, do: todo, else: find_by_id(rest, id)
  end

  def find_index_by_id todos, id do
    find_index todos, fn %{id: an_id} -> an_id == id end
  end

  def find_index todos, fun do
    find_index todos, fun, 0
  end

  def find_index [], fun, pos do
    nil
  end

  def find_index todos, fun, pos do
    if fun.(List.first todos), do: pos, else: find_index(Enum.drop(todos, 1), fun, pos + 1)
  end
end
