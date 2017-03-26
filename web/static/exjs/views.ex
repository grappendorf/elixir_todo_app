defmodule Views do
  use ReactUI

  @key_enter 13
  @key_escape 27

  def render state, _ do
    state
    |> Views.page
    |> ReactDOM.render(:document.getElementById("app"))
  end

  def page state do
    ReactUI.div do
      page_title state
      todo_input state
      todo_list state
      help state
    end
  end

  def page_title state do
    h1 className: "text-center" do
      i className: "fa fa-check"
      " Elixir Todo App"
    end
  end

  def todo_input state do
    ReactUI.div className: "input-group todo-input tutor-container" do
      input autoFocus: true, className: "form-control",
        value: state.new_todo_text, placeholder: "What do you want to do?",
        onChange: fn event -> Store.dispatch {:new_todo_text, event.target.value} end,
        onKeyUp: fn event, _ ->
          if event.keyCode == @key_enter && state.new_todo_text != "", do:
            Store.dispatch {:add_todo, state.new_todo_text}
        end
      i className: "fa fa-plus btn btn-default input-group-addon",
        disabled: state.new_todo_text == "",
        onClick: fn _, _ -> Store.dispatch {:add_todo, state.new_todo_text} end
      tutor :add_todo, state
    end
  end

  def todo_list state do
    ReactUI.div do
      ReactUI.div className: "checkbox pull-right" do
        label do
          input type: "checkbox", value: state.hide_done,
            onChange: fn event -> Store.dispatch {:hide_done, event.target.checked} end
          "Hide done"
        end
        tutor :hide_done, state
      end
      table className: "table table-bordered table-striped tutor-container" do
        tbody do
          state.todos
          |> Enum.filter(fn todo -> !state.hide_done || todo.status != :done end)
          |> Enum.map(fn todo -> todo_item todo, state.edit_todo end)
        end
        caption do
          tutor :edit_todo, state
          tutor :edit_todo_actions, state
        end
      end
    end
  end

  def todo_item todo, edit_todo do
    if edit_todo && edit_todo.id == todo.id do
      todo_item_editor todo, edit_todo
    else
      todo_item_text todo
    end
  end

  def todo_item_editor todo, edit_todo do
    tr key: todo.id do
      td className: "width-100" do
        input value: edit_todo.text, autoFocus: true, className: "form-control",
          onChange: fn event ->
            Store.dispatch {:edit_todo_text, event.target.value}
          end,
          onKeyUp: fn event, _ ->
            if event.keyCode == @key_enter && edit_todo.text != "", do:
              Store.dispatch {:update_todo, edit_todo.id, edit_todo.text}
            if event.keyCode == @key_escape, do: Store.dispatch {:cancel_edit_todo}
          end
        ReactUI.div className: "pull-right todo-actions" do
          i className: "fa btn fa-save btn-success",
            disabled: edit_todo.text == "",
            onClick: fn _, _ -> Store.dispatch {:update_todo, edit_todo.id, edit_todo.text} end
          i className: "fa btn fa-remove btn-info",
            onClick: fn _, _ -> Store.dispatch {:cancel_edit_todo} end
          i className: "fa btn #{done_button_class todo}",
            onClick: fn _, _ -> Store.dispatch {:toggle_todo, todo.id} end
          i className: "fa fa-trash btn btn-danger",
            onClick: fn _, _ ->
              confirm "Do you really want to delete the todo <b>\"#{edit_todo.text}\"</b>?",
                fn -> Store.dispatch {:delete_todo, todo.id} end,
                fn -> Store.dispatch {:cancel_edit_todo} end
            end
        end
      end
    end
  end

  def todo_item_text todo do
    tr key: todo.id do
      td className: "width-100",
        onClick: fn _, _ -> Store.dispatch {:edit_todo, todo.id} end do
        span className: todo_text_class(todo) do
          todo.text
        end
      end
    end
  end

  def done_button_class(%{status: :todo}), do: "fa-check btn-success"
  def done_button_class(%{status: :done}), do: "fa-gear btn-warning"

  def todo_text_class(%{status: :todo}), do: "text-bold"
  def todo_text_class(%{status: :done}), do: "text-strikethrough text-italic"

  def help state do
    ReactUI.div className: "pull-right tutor-container" do
      small do
        "Version #{state.config.version} | "
        a href: "http://www.grappendorf.net", do: "www.grappendorf.net"
        " | "
        end
      ReactUI.a href: "#",
        onClick: fn _, _ -> Store.dispatch {:start_tutor, :add_todo} end do
        "Tutorial"
      end
      tutor :show_tutorial, state
    end
  end

  def confirm msg, fun_ok, fun_cancel do
    dialog = JS.new(ModalVanilla, [%{"title" => "Please confirm", "content" => msg}])
    dialog.on "dismiss", fn _, _, button ->
      if button.value, do: fun_ok.(), else: fun_cancel.()
    end
    dialog.show()
  end

  def tutor :add_todo, %{tutor: :add_todo} do
    ReactUI.div className: "tutor tutor-left",
      onClick: fn _, _ -> Store.dispatch {:next_tutor} end do
      "Click here to write your first todo. Press enter or click "
      i className: "fa btn fa-plus btn-default"
      " to add it to the list."
    end
  end

  def tutor :edit_todo, %{tutor: :edit_todo} do
    ReactUI.div className: "tutor tutor-left",
      onClick: fn _, _ -> Store.dispatch {:next_tutor} end do
      "Click on a todo to edit it."
    end
  end

  def tutor :edit_todo_actions, %{tutor: :edit_todo_actions} do
    ReactUI.div className: "tutor tutor-left",
      onClick: fn _, _ -> Store.dispatch {:next_tutor} end do
        "You can save your changes "
        i className: "fa btn fa-save btn-success"
        ", cancel your changes "
        i className: "fa btn fa-remove btn-info"
        ", toggle the todo status "
        i className: "fa btn fa-check btn-success"
        " and delete a todo"
        i className: "fa fa-trash btn btn-danger"
        "."
    end
  end

  def tutor :hide_done, %{tutor: :hide_done} do
    ReactUI.div className: "tutor tutor-right",
      onClick: fn _, _ -> Store.dispatch {:next_tutor} end do
      "Show only unfinished tasks by activating this checkbox."
    end
  end

  def tutor :show_tutorial, %{tutor: :show_tutorial} do
    ReactUI.div className: "tutor tutor-right",
      onClick: fn _, _ -> Store.dispatch {:next_tutor} end do
      "Click here to show the tutorial again."
    end
  end

  def tutor _, _ do
  end
end
