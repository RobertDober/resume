defmodule Resume.Tools.TransformLinksTest do
  use ExUnit.Case
  alias Resume.Tools, as: T
  
  @datum [{"role", "Maintainer"}, {"url", "https://github.com/pragdave/earmark"}]
  test "transform a link" do
    assert T.make_links_for(@datum, "url") == 
      [{"role", "Maintainer"}, {"url", "<a href=\"https://github.com/pragdave/earmark\">https://github.com/pragdave/earmark</a>"}]
  end
end
