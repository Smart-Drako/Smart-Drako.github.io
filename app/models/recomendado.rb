class Recomendado < ApplicationRecord
  def self.buscar_abuelo(padre_id)
    return Recomendado.find_by(id_usuario: padre_id)
  end
end
