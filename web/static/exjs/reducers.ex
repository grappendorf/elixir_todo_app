defmodule Reducers do
  def reduce state, {:load_todos, todos} do
    %{state | todos: todos}
  end

  def reduce state, {:new_todo_text, text} do
    %{state | new_todo_text: text}
  end

  def reduce state = %{todos: todos}, {:add_todo, id, text} do
    %{state | todos: [Todo.new(id, text) | todos], new_todo_text: ""}
  end

  def reduce state = %{todos: todos}, {:edit_todo, id} do
    %{state | edit_todo: Todo.find_by_id(todos, id)}
  end

  def reduce state = %{edit_todo: todo}, {:edit_todo_text, text} do
    %{state | edit_todo: %{todo | text: text}}
  end

  def reduce state = %{todos: todos}, {:update_todo, id, text} do
    %{state | todos: Todo.update(todos, id, fn todo -> %{todo | text: text} end),
      edit_todo: nil}
  end

  def reduce state = %{todos: todos}, {:undo_todo, todo} do
    %{state | todos: Todo.update(todos, todo.id, fn _ -> todo end)}
  end

  def reduce state, {:cancel_edit_todo} do
    %{state | edit_todo: nil}
  end

  def reduce state = %{todos: todos}, {:delete_todo, id} do
    %{state | todos: Todo.delete(todos, id)}
  end

  def reduce state = %{todos: todos}, {:toggle_todo, id} do
    %{state | todos: Todo.toggle(todos, id), edit_todo: nil}
  end

  def reduce state = %{todos: todos}, {:todo_was_created, temp_id, id, text, status} do
    case Todo.find_by_id todos, temp_id do
      nil -> %{state | todos: [Todo.new(id, text, status) | todos]}
      _ -> %{state | todos: Todo.update(todos, temp_id, fn todo -> %{todo | id: id} end)}
    end
  end

  def reduce state = %{todos: todos}, {:todo_was_updated, id, text, status} do
    %{state | todos: Todo.update(todos, id, fn _ -> Todo.new(id, text, status) end)}
  end

  def reduce state = %{todos: todos}, {:todo_was_deleted, id} do
    %{state | todos: Todo.delete(todos, id)}
  end

  def reduce state, {:hide_done, value} do
    %{state | hide_done: value}
  end

  def reduce state, {:start_tutor, tutor} do
    %{state | tutor: tutor}
  end

  def reduce state = %{tutor: tutor}, {:next_tutor} do
    %{state | tutor: case tutor do
      :add_todo -> :edit_todo
      :edit_todo -> :edit_todo_actions
      :edit_todo_actions -> :hide_done
      :hide_done -> :show_tutorial
      _ -> :done
    end}
  end

  def reduce state, _ do
    state
  end
end
