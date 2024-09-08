defmodule Api do
  @moduledoc """
  Documentation for `Api`.
  Modulo para fazer solicitação da API
  """

  def get(url) do
    HTTPoison.get(url)
    |> process_response
    |> process_result
  end

  @spec build_url(binary(), list(map())) :: binary()
  def build_url(base_url, params) when is_binary(base_url) and is_list(params) do
    case params do
      [] ->
        base_url

      _ ->
        query_string =
          params
          |> Enum.map(&format_param/1)
          |> Enum.join("&")

        "#{base_url}?#{query_string}"
    end
  end

  defp format_param(%{param: param, term: term}) when is_binary(param) and is_binary(term) do
    "#{param}=#{URI.encode(term)}"
  end

  defp format_param(_invalid_param) do
    raise ArgumentError, "Each param must be a map with :param and :term as strings"
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: b}}) do
    {:ok, b}
  end

  defp process_response({:error, r}), do: {:error, r}

  defp process_response({:ok, %HTTPoison.Response{status_code: _, body: b}}) do
    {:error, b}
  end

  defp process_result({:error, _}) do
    IO.puts("Erro na requisição")
  end

  defp process_result({:ok, json}) do
    {:ok, data} = Poison.decode(json)
    data
  end
end
