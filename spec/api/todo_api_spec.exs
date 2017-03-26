defmodule CaretakerServer.StatusControllerSpec do
  use ESpec.Phoenix, controller: StatusController, async: true
  use TestThatJson.ESpec
  import ElixirTodoApp.TodoFactory
  import Ecto.Query
  alias ElixirTodoApp.{Todo, Repo}

  describe "GET /api/todos" do
    let :conn do
      get build_conn(), "/api/todos"
    end

    context "when todos exist" do
      let! :todos, do: for _ <- 1..3, do: insert(:todo, %{})
      it "should return the list of all todos" do
        expect(json_response conn(), 200)
          .to eq todos() |> Enum.reverse |> Enum.map(fn todo -> %{
              "id" => todo.id,
              "status" => Atom.to_string(todo.status),
              "text" => todo.text}
          end)
      end
    end

    context "when no todos exist" do
      it "should return an empty list" do
        expect(json_response conn(), 200).to eq []
      end
    end
  end

  describe "GET /api/todos/:id" do
    let :todo, do: insert(:todo, %{})
    let :todo_id, do: todo().id
    let :conn do
      get build_conn(), "/api/todos/#{todo_id()}"
    end

    context "when the requested todo exists" do
      it "should return the todo" do
        expect(json_response conn(), 200).to eq %{
          "id" => todo().id,
          "text" => todo().text,
          "status" => Atom.to_string(todo().status)}
      end
    end

    context "when the requested todo exists" do
      let :todo_id, do: -1
      it "should return the status code not found" do
        expect(json_response conn(), 404)
      end
    end
  end

  describe "POST /api/todos" do
    let :conn do
      post build_conn(), "/api/todos", %{"text" => "Write documentation"}
    end

    it "should create a new todo" do
      expect(fn -> conn() end).to change fn -> Todo |> Repo.count end, 0, 1
    end

    it "should store the todo text" do
      conn()
      expect((from t in Todo, select: t.text) |> Repo.all |> List.first)
        .to eq "Write documentation"
    end

    it "should return the id of the new todo" do
      expect(json_response conn(), 201).to have_key "id"
    end
  end

  describe "PUT /api/todos/:id" do
    let! :todo, do: insert(:todo, %{text: "Old todo text"})
    let :conn do
      put build_conn(), "/api/todos/#{todo().id}", %{"text" => "New todo text"}
    end

    it "should update the todo text" do
      expect(fn -> conn() end).to change fn ->
        (from t in Todo, select: t.text) |> Repo.all |> List.first
      end, "Old todo text", "New todo text"
    end

    it "should return the status code no content" do
      expect(json_response conn(), 204)
    end
  end

  describe "DELETE /api/todos/:id" do
    let! :todo, do: insert(:todo, %{})
    let :conn do
      delete build_conn(), "/api/todos/#{todo().id}"
    end

    it "should delete the todo" do
      expect(fn -> conn() end).to change fn -> Todo |> Repo.count end, 1, 0
    end

    it "should return the status code no content" do
      expect(json_response conn(), 204)
    end
  end

  describe "POST /api/todos/:id/states" do
    let! :todo, do: insert(:todo, %{status: :todo})
    let :conn do
      post build_conn(), "/api/todos/#{todo().id}/states", %{"status" => "done"}
    end

    it "should update the todo status" do
      expect(fn -> conn() end).to change fn ->
        (from t in Todo, select: t.status) |> Repo.all |> List.first
      end, :todo, :done
    end

    it "should return the status code no content" do
      expect(json_response conn(), 204)
    end
  end
end
