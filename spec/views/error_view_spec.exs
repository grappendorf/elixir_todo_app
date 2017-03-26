defmodule ElixirTodoApp.ErrorViewSpec do
  use ESpec.Phoenix, view: ErrorView, async: true

  describe "renders 404.html" do
    it "should return render a page not found error" do
      expect(render_to_string(ElixirTodoApp.ErrorView, "404.html", []))
        .to eq "Page not found"
    end
  end

  describe "render 500.html" do
    it "should return render an internal server error" do
      expect(render_to_string(ElixirTodoApp.ErrorView, "500.html", []))
        .to eq "Internal server error"
    end
  end
end
