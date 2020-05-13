class Producto < ApplicationRecord
  belongs_to :user

  def self.importar(file, current_user)
    excel = abrir_excel(file)
    header = excel.row(1)
    (2..excel.last_row).each do |i|
      row = Hash[[header, excel.row(i)].transpose]
      prod = find_by(id: row["ID"], user_id: current_user.id) || new
      prod.user_id = current_user.id
      prod.codigo = row["Artículo"]
      prod.inventario = row["Inventario"]
      prod.categoria = row["Categoria"]
      prod.descripcion = row["Descripción"]
      prod.unidad = row["Unidad"]
      prod.precio = row["Precio"]
      prod.impuesto = row["Impuesto"]
      prod.save!
    end
  end

  def self.abrir_excel(file)
    case File.extname(file.original_filename)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "El archivo no es tiene formato .xls | .xlsx: #{file.original_filename}"
    end
  end

end
