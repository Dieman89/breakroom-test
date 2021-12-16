defmodule ExTest do
  use ExUnit.Case
  doctest Ex

  test "on Ex.check_contracted_hours/2 that exceeding hours worked by more than 8 gives +1 on total and +0 on points" do
    initial_score = %Ex.Score{points: 0, total: 0}
    data = %{"contracted_hours" => 20, "hours_actually_worked" => 34}
    assert Ex.check_contracted_hours(initial_score, data) == %Ex.Score{points: 0, total: 1}
  end

  test "on Ex.check_contracted_hours/2 that not exceeding hours worked by more than 8 gives +1 on total and +1 on points" do
    initial_score = %Ex.Score{points: 0, total: 0}
    data = %{"contracted_hours" => 0, "hours_actually_worked" => 8}
    assert Ex.check_contracted_hours(initial_score, data) == %Ex.Score{points: 1, total: 1}
  end
end
