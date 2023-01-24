defmodule NginxLivebookUtilsTest do
  use ExUnit.Case
  doctest NginxLivebookUtils

  test "greets the world" do
    assert NginxLivebookUtils.hello() == :world
  end
end
