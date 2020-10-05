class ApplicationController < ActionController::Base
  before_action :configure_devise_params, if: :devise_controller?

  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:nombre,:apellido, :email, :password, :password_confirmation, :ref)
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || me_path
  end

  def vencimiento_cuenta(user)
    fecha_vence = user.fecha_vencimiento.to_date
    hoy = Time.now.to_date
    dias_restantes = (fecha_vence - hoy).to_i
    if dias_restantes <= 0
      vencimiento = "Hola, tu cuenta está Suspendida. Favor de realizar tu pago para que sigas recibiendo pedidos en línea."
    elsif dias_restantes < 16
      vencimiento = "Aviso, tu cuenta vence en #{dias_restantes} día(s)."
    else
      vencimiento = ""
    end
  end

  def cuenta_suspendida
    if current_user.present?
      usuario = ConfigUser.find_by(user_id: current_user.id)
      return usuario.estatus == 2 ? true : false
    else
      return true
    end
  end

end
