class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.valid?
        c_usuario = ConfigUser.find_or_create_by(user_id: resource.id)
        if c_usuario.save!
          activar_prueba_gratis(c_usuario)
        end
      end
    end
  end

  private
  def activar_prueba_gratis(c_usuario)
    plan_prueba = Plan.find(1)
    c_usuario.estatus = 1 #Activo
    c_usuario.plan_id = plan_prueba.id #Prueba gratis
    c_usuario.fecha_registro = Time.now
    c_usuario.fecha_inicio = Time.now
    c_usuario.fecha_vencimiento = Time.now.to_date + plan_prueba.vigencia.to_i
    if c_usuario.save!
      puts "Usuario Con plan gratis"
    end
  end
end