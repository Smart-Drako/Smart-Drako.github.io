class HomeController < ApplicationController
  def index
    @categorias = {
      "cat-1" => "Asadero",
      "cat-2" => "Barbería",
      "cat-3" => "Abarrotes",
      "cat-4" => "Pizzas",
      "cat-5" => "Sushi",
      "cat-6" => "Ferretería",
      "cat-7" => "Postres",
      "cat-8" => "Botanas",
    }
  end
end
