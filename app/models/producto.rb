class Producto < ApplicationRecord
  belongs_to :user
  mount_uploader :foto, FotoUploader

  def self.importar(file, current_user)
    excel = abrir_excel(file)
    header = excel.row(1).map{ |x| I18n.transliterate(x.downcase) }
    (2..excel.last_row).each do |i|
      row = Hash[[header, excel.row(i)].transpose]
      prod = find_by(id: row["id"], user_id: current_user.id) || new
      prod.user_id = current_user.id
      prod.codigo = row["sku"]
      prod.inventario = row["inventario"]
      prod.categoria = row["categoria"]
      prod.descripcion = row["descripcion"]
      prod.unidad = row["unidad"]
      prod.precio = row["precio"]
      prod.impuesto = row["impuesto"]
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
