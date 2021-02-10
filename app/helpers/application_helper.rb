module ApplicationHelper
  def current_class?(test_path)
    return request.path == test_path ? "active" : ""
  end
  def hide_class_movil?(test_path)
    return request.path == test_path ? 'd-none' : 'd-block d-lg-none'
  end
  def hide_class_web?(test_path)
    return request.path == test_path ? 'd-none' : 'd-none d-lg-block'
  end
  def pedido_recomendado(id)
    embajador = ConfigUser.find(id) if id.present?
    usuario = User.find(embajador.user_id) if embajador.present?
    if usuario.present?
      return "Recibiste este pedido por recomendacion de #{usuario.nombre} #{usuario.apellido}"
    else
      return ""
    end
  end
end
