defmodule Ex do
  @doc """
  Take a JSON and generate a score based on key-value pairs.

  ## Examples


      iex> Ex.main("answers.json")
      "You scored 3 out of 5 (60.0%)."

  """
  def main(filename) do
    initial_score = %Ex.Score{points: 0, total: 0}

    data = get_json(filename)

    initial_score
    |> check_contracted_hours(data)
    |> score_by_key(data, "enjoys_job")
    |> score_by_key(data, "respected_by_managers")
    |> score_by_key(data, "good_for_carers")
    |> score_by_key(data, "unpaid_extra_work")
    |> check_hourly_rate(data)
    |> format_text
  end

  @doc """
  Returns a map from a JSON file.

  ## Examples


      iex> Ex.get_json("answers.json")
      %{
      "age" => 26,
      "contracted_hours" => 20,
      "enjoys_job" => "yes",
      "good_for_carers" => "yes",
      "hourly_rate" => "£8.22",
      "hours_actually_worked" => 34,
      "respected_by_managers" => "no",
      "submitted_date" => 1608211454000,
      "unpaid_extra_work" => "unsure"
      }

  """
  def get_json(filename) do
    with {:ok, json} <- File.read(filename),
         {:ok, map} <- Poison.decode(json) do
      map
    end
  end

  @doc """
  Take a map and an Ex.Score struct and returns an Ex.Score struct with updated points and total.
  If the hours worked exceed the contracted hours by 8, it will only update the total, otherwise it
  will add 1 on both.

  ## Examples


      iex> initial_score = %Ex.Score{points: 0, total: 0}
      %Ex.Score{points: 0, total: 0}
      iex> data = %{"contracted_hours" => 20, "hours_actually_worked" => 34}
      %{"contracted_hours" => 20, "hours_actually_worked" => 34}
      iex> Ex.check_contracted_hours(initial_score, data)
      %Ex.Score{points: 0, total: 1}

  """
  @spec check_contracted_hours(current_score :: Ex.Score.t(), map :: map()) ::
          {:ok, Ex.Score.t()} | :error
  def check_contracted_hours(%Ex.Score{} = current_score, map) do
    with {:ok, contracted_hours} <- Map.fetch(map, "contracted_hours"),
         {:ok, worked_hours} <- Map.fetch(map, "hours_actually_worked") do
      extra_hours = abs(contracted_hours - worked_hours)

      if extra_hours >= 9 do
        %Ex.Score{current_score | total: current_score.total + 1}
      else
        %Ex.Score{
          current_score
          | points: current_score.points + 1,
            total: current_score.total + 1
        }
      end
    end
  end

  @doc """
  Take a map, an Ex.Score struct and a key. Returns an Ex.Score struct with updated points and total.
  If the value of the key is a valid "yes" or "no" then it will add 1 on the points, otherwise it
  will add 0. If the value is different from "yes" or "no" then it will add 0 on both.

  ## Examples


      iex> initial_score = %Ex.Score{points: 0, total: 0}
      %Ex.Score{points: 0, total: 0}
      iex> data = %{"enjoys_job" => "yes"}
      %{"enjoys_job" => "yes"}
      iex> Ex.score_by_key(initial_score, data, "enjoys_job")
      %Ex.Score{points: 1, total: 1}

  """
  def score_by_key(%Ex.Score{} = current_score, map, key) do
    with {:ok, response} <- Map.fetch(map, key) do
      case response do
        "yes" ->
          %Ex.Score{
            current_score
            | points: current_score.points + 1,
              total: current_score.total + 1
          }

        "no" ->
          %Ex.Score{current_score | total: current_score.total + 1}

        _ ->
          current_score
      end
    end
  end

  @doc """
  Take a map and an Ex.Score struct. Returns an Ex.Score struct with updated points and total.
  If the value of the key is higher or equal to 8.21, it will add 1 on the points and total,
  otherwise it will add 0 on points and 1 on total.

  ## Examples


      iex> initial_score = %Ex.Score{points: 0, total: 0}
      %Ex.Score{points: 0, total: 0}
      iex> data = %{"hourly_rate" => "£8.22"}
      %{"hourly_rate" => "£8.22"}
      iex> Ex.check_hourly_rate(initial_score, data)
      %Ex.Score{points: 1, total: 1}

  """
  def check_hourly_rate(%Ex.Score{} = current_score, map) do
    with {:ok, hourly_pay} <- Map.fetch(map, "hourly_rate") do
      current_pay =
        String.replace(hourly_pay, "£", "")
        |> String.to_float()

      if current_pay >= 8.21 do
        %Ex.Score{
          current_score
          | points: current_score.points + 1,
            total: current_score.total + 1
        }
      else
        %Ex.Score{
          current_score
          | total: current_score.total + 1
        }
      end
    end
  end

  @doc """
  Takes an Ex.Score struct and returns a formatted string.

  ## Examples


      iex> score = %Ex.Score{points: 3, total: 5}
      %Ex.Score{points: 3, total: 5}
      iex> Ex.format_text(score)
      "You scored 3 out of 5 (60.0%)."

  """
  def format_text(%Ex.Score{} = current_score) do
    "You scored #{current_score.points} out of #{current_score.total} (#{current_score.points / current_score.total * 100}%)."
  end
end
