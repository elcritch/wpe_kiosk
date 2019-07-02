defmodule WpeKioskTest do
  use ExUnit.Case
  doctest WpeKiosk

  test "greets the world" do
    assert WpeKiosk.hello() == :world
  end
end
