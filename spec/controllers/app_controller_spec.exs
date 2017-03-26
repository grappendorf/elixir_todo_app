defmodule ElixirTodoApp.AppControllerSpec do
  use ESpec.Phoenix, controller: AppController, async: true

  describe "GET /" do
    let :conn do
      get build_conn(), "/"
    end

    it "should return the status ok" do
      expect(response conn(), 200).to match "Elixir Todo App"
    end
  end
end
