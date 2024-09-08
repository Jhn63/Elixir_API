defmodule Game do
  @moduledoc """
  Módulo que implementa o jogo de adivinhar a carta usando o módulo Magic.
  """

  def start_game() do
    IO.puts("Bem-vindo ao jogo de adivinhar a carta!")
    cartas = Magic.mostrar_cartas()

    if length(cartas) == 0 do
      IO.puts("Nenhuma carta encontrada.")
    else
      carta_secreta = escolher_carta_aleatoria(cartas)
      IO.puts("Eu escolhi uma carta. Tente adivinhar!")
      IO.puts(carta_secreta["name"])

      loop_adivinhar(carta_secreta)
    end
  end

  defp escolher_carta_aleatoria(cartas) do
    Enum.random(cartas)
  end

  defp loop_adivinhar(carta_secreta) do
    IO.puts("Qual é o nome da carta?")
    chute = IO.gets("> ") |> String.trim()

    if chute == carta_secreta["name"] do
      IO.puts("Parabéns! Você acertou a carta!")
    else
      IO.puts("Errou! Vou te dar uma dica:")
      fornecer_dica(carta_secreta)
      loop_adivinhar(carta_secreta)
    end
  end

  defp fornecer_dica(carta) do
    dicas = [
      fn -> "Tipo da carta: #{carta["type"]}" end,
      fn -> "Custo de mana: #{carta["manaCost"]}" end,
      fn -> "Poder: #{carta["power"] || "N/A"}" end,
      fn -> "Resistência: #{carta["toughness"] || "N/A"}" end
    ]

    dica_aleatoria = Enum.random(dicas)
    # Garantir que a função seja chamada corretamente
    IO.puts(dica_aleatoria.())
  end
end
