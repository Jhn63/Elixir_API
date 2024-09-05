defmodule Api do
  @moduledoc """
  Documentation for `Api`.
  Modulo para fazer solicitação da API
  """

  def obtem_resposta(url) do
    HTTPoison.get(url)
    |> processa_resposta
    |> processa_resultado
  end

  defp processa_resposta({:ok, %HTTPoison.Response{status_code: 200, body: b}}) do
    {:ok, b}
  end

  defp processa_resposta({:error, r}), do: {:error, r}
  defp processa_resposta({:ok, %HTTPoison.Response{status_code: _, body: b}}) do
    {:error, b}
  end

  defp processa_resultado({:error,_}) do
    IO.puts("Erro na requisição")
  end

  defp processa_resultado({:ok, json}) do
    {:ok, data} = Poison.decode(json)
    data
  end

end
