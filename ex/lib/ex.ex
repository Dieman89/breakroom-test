defmodule Ex do
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
  end

  def get_json(filename) do
    with {:ok, json} <- File.read(filename),
         {:ok, map} <- Poison.decode(json) do
      map
    end
  end

  @spec check_contracted_hours(current_score :: Ex.Score.t(), map :: map()) ::
          {:ok, Ex.Score.t()} | :error
  def check_contracted_hours(%Ex.Score{} = current_score, map) do
    with {:ok, contracted_hours} <- Map.fetch(map, "contracted_hours"),
         {:ok, worked_hours} <- Map.fetch(map, "hours_actually_worked") do
      additional_hours = abs(contracted_hours - worked_hours)

      if additional_hours >= 9 do
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
        current_score
      end
    end
  end
end
