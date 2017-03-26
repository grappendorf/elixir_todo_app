defmodule ElixirTodoApp.ModelHelpers do
  alias ElixirTodoApp.Repo

  def load_model(model, params) when is_list(params) do
    case Repo.get_by model, params do
      nil -> {:error_load}
      instance -> {:ok, instance}
    end
  end

  def load_model model, id do
    case Repo.get model, id do
      nil -> {:error_load}
      instance -> {:ok, instance}
    end
  end

  def create_model instance do
    case Repo.insert instance do
      {:ok, instance} -> {:ok, instance}
      {:error, %{errors: errors}} -> {:error_create, errors}
    end
  end

  def update_model instance do
    case Repo.update instance do
      {:ok, instance} -> {:ok, instance}
      {:error, %{errors: errors}} -> {:error_update, errors}
    end
  end

  def delete_model instance do
    case Repo.delete instance do
      {:ok, instance} -> {:ok, instance}
      {:error, %{errors: errors}} -> {:error_delete, errors}
    end
  end
end
