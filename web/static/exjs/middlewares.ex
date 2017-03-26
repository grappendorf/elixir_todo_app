defmodule Middlewares do
  def api :pre, _, _, {:load_todos} do
    do_get "/api/todos", fn json ->
      todos = Enum.map json, &(Todo.new_from_json &1)
      Store.dispatch {:load_todos, todos}
    end
    {}
  end

  def api :pre, _, _, {:add_todo, text} do
    temp_id = Date.now()
    todo_json = %{"temp_id" => temp_id, "text" => text}
    do_post "/api/todos", todo_json, fn _ -> end, fn _ ->
      show_error_toast "Server error while creating the todo."
      Store.dispatch {:todo_was_deleted, temp_id}
    end
    {:add_todo, temp_id, text}
  end

  def api :post, %{todos: todos}, %{todos: old_todos}, action = {:update_todo, id, _} do
    todo = Todo.find_by_id(todos, id)
    todo_json = %{"text" => todo.text, "status" => Atom.to_string(todo.status)}
    do_put "/api/todos/#{id}", todo_json, fn _ -> end, fn _ ->
      show_error_toast "Server error while updating the todo."
      Store.dispatch {:undo_todo, Todo.find_by_id(old_todos, id)}
    end
    action
  end

  def api :post, %{todos: todos}, %{todos: old_todos}, action = {:toggle_todo, id} do
    %{status: status} = Todo.find_by_id(todos, id)
    status_json = %{"status" => Atom.to_string(status)}
    do_post "/api/todos/#{id}/states", status_json, fn _ -> end, fn _ ->
      show_error_toast "Server error while updating the todo status."
      Store.dispatch {:undo_todo, Todo.find_by_id(old_todos, id)}
    end
    action
  end

  def api :post, _, %{todos: old_todos}, action = {:delete_todo, id} do
    do_delete "/api/todos/#{id}", fn _ -> end, fn _ ->
      show_error_toast "Server error while deleting the todo."
      Store.dispatch {:cancel_edit_todo}
      Store.dispatch {:load_todos, old_todos}
    end
    action
  end

  def api _, _, _, action do
    action
  end

  def tutor :pre, _, _, {:start_tutor} do
    case :window.localStorage.getItem("tutor") do
      nil -> {:start_tutor, :add_todo}
      next -> {:start_tutor, String.to_atom(next)}
      "done" -> {}
    end
  end

  def tutor :post, %{tutor: tutor}, _, {:next_tutor} do
    :window.localStorage.setItem "tutor", Atom.to_string(tutor)
  end

  def tutor _, _, _, action do
    action
  end

  def do_get path, success \\ fn _ -> end , error \\ fn _ -> end do
    call_api path, "GET", nil, success, error
  end

  def do_post path, data, success \\ fn _ -> end , error \\ fn _ -> end do
    call_api path, "POST", data, success, error
  end

  def do_put path, data, success \\ fn _ -> end , error \\ fn _ -> end do
    call_api path, "PUT", data, success, error
  end

  def do_delete path, success \\ fn _ -> end , error \\ fn _ -> end  do
    call_api path, "DELETE", "", success, error
  end

  def call_api path, method, data, success, error do
    options = %{
      "method" => method,
      "headers" => %{"Content-Type" => "application/json"},
    }
    options_with_body = case data do
      nil -> options
      _ -> Map.put(options, "body", JSON.stringify(data))
    end
    :window.fetch(path, options_with_body).then(fn response ->
      unless response.ok, do: raise Error
      case response.status do
        204 -> success.(nil)
        _ -> response.json.then fn json -> success.(json) end
      end
    end).catch(error)
  end

  def show_error_toast msg do
    :window.spop %{
      "template" => "#{msg}<br><br>Please try again later.",
      "style" => "error",
      "autoclose" => 5000
    }
  end
end
