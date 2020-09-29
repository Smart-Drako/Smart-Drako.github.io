class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.valid?
        c_usuario = ConfigUser.find_or_create_by(user_id: resource.id)
        if c_usuario.save!
          activar_prueba_gratis(c_usuario)
          guardar_referenciados(c_usuario, params["ref"]) if params["ref"].present?
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
    c_usuario.pedidos_restantes = plan_prueba.no_pedidos
    c_usuario.save!
  end

  def guardar_referenciados(nuevo_user, referenciador_id)
    referenciador_id = Base64.decode64(id).to_i
    puts "Ref: #{referenciador_id}"
  end
end