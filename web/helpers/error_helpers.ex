defmodule ElixirTodoApp.ErrorHelpers do
  use Phoenix.HTML

  def render_model_errors conn, errors do
    response = %{
      error: %{
        errors: Enum.map(errors, fn {field, {message, _}} -> %{attribute: field, message: message} end)}}
    Phoenix.Controller.json conn, response
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(CaretakerServer.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(CaretakerServer.Gettext, "errors", msg, opts)
    end
  end

  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end
end
