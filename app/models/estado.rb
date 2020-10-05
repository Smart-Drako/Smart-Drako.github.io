class Estado < ApplicationRecord
  def self.ciudades_estado(estado)
    return Estado.where(estado: estado)
  end
end
