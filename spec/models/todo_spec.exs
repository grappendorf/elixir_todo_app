defmodule ElixirTodoApp.TodoSpec do
  use ESpec.Phoenix, model: Todo, async: true
  import ElixirTodoApp.TodoFactory
  alias ElixirTodoApp.Todo

  let :todo, do: build :todo, %{}

  it do: todo().id
  it do: todo().text
  it do: todo().status
  it do: todo().inserted_at
  it do: todo().updated_at

  describe "changeset/2" do
    describe "if all attributes are valid" do
      it "should be valid" do
        expect(Todo.changeset(todo(), %{}).valid?).to be_true()
      end
    end

    describe "if the text is empty" do
      let :params, do: %{text: ""}
      it "should be invalid" do
        expect(Todo.changeset(todo(), params()).valid?).to be_false()
      end
    end
  end
end
