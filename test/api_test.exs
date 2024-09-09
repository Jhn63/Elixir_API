defmodule ApiTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Api
  alias Magic


  # Testes p o modulo Api 
  describe "Api.get/1" do
    test "deve retornar dados corretamente quando a API responde com sucesso" do
      url = "https://api.magicthegathering.io/v1/cards"
      result = Api.get(url)
      
      assert Map.has_key?(result, "cards")
    end


    test "deve lidar com erro quando a URL é inválida" do
      url = "https://invalido.com"
      result = Api.get(url)

      assert :ok = result
    end
  end

  describe "Api.build_url/2" do
    test "deve construir a URL corretamente com parâmetros" do
      base_url = "https://api.abdesc.com"
      params = [%{param: "page", term: "1"}, %{param: "size", term: "10"}]
      url = Api.build_url(base_url, params)
      assert url == "https://api.abdesc.com?page=1&size=10"
    end

    test "deve retornar a URL base se não houver parâmetros" do
      base_url = "https://api.abdesc.com"
      url = Api.build_url(base_url, [])
      assert url == base_url
    end
  end


  # Testes do mdulo Magic
  describe "Magic.get_cards/0" do
    test "deve retornar uma lista de cartas" do
      cards = Magic.get_cards()
      assert is_list(cards)
      assert length(cards) > 0
    end
  end

  describe "Magic.get_color/1" do
    test "deve retornar o código de cor correto" do
      assert Magic.get_color("Red") == "R"
      assert Magic.get_color("Blue") == "U"
    end

    test "deve retornar 'Cor inválida' para cores desconhecidas" do
      assert Magic.get_color("Purple") == "Cor inválida"
    end
  end

  describe "Magic.get_types/0" do
    test "deve retornar uma lista de tipos de cartas" do
      types = Magic.get_types()
      assert is_list(types)
    end
  end
end
