defmodule LandOfDiscordia.Api do
  @key "926102739251620372"

  def get_tech_key(%Database.Repo.Account{id: id}), do: get_tech_key(id)
  def get_tech_key(id) do
    "user"
    |> get("id=#{id}")
    |> Map.get("code")
  end

  defp get(route, params) do
    "http://landofdiscordia.herokuapp.com/api/#{route}?key=#{@key}&#{params}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
