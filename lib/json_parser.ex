defmodule JSONParser do
  def fetch_and_parse_data(url) do
    headers = [
      {"x-api-key", "0TvQnueqKa5mxJntVWt0w4LpLfEkrV1Ta8rQBb9Z"}
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decode_nested(body)

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}

      {:error, reason} ->
        {:error, "Request error: #{reason}"}
    end
  end

  def decode_nested(json) when is_binary(json) do
    case decode(json) do
      {:ok, parsed_json} ->
        decode_nested(parsed_json)

      {:error, _reason} ->
        {:error, "Error decoding JSON"}
    end
  end

  def decode_nested(%{} = map) do
    decode_nested_map(map)
  end

  def decode_nested(_other) do
    {:error, "Unknown JSON structure"}
  end

  defp decode_nested_map(map) do
    Enum.reduce(%{}, map, fn {key, value}, acc ->
      case value do
        %{} ->
          new_value = decode_nested_map(value)
          Map.put(acc, key, new_value)

        _ ->
          Map.put(acc, key, value)
      end
    end)
  end

  defp decode(json) do
    Jason.decode(json)
  end
end
