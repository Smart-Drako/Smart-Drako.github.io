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
  def pedido_recomendado(id, descr = true)
    embajador = ConfigUser.find(id) if id.present?
    usuario = User.find(embajador.user_id) if embajador.present?
    if usuario.present?
      if descr == true
        return "Recibiste este pedido por recomendación de #{usuario.nombre} #{usuario.apellido}"
      else
        return "#{usuario.nombre} #{usuario.apellido}"
      end
    else
      return ""
    end
  end

  def pedido_recomendado_emprendedor(id)
    emprendedor = ConfigUser.find(id) if id.present?
    return emprendedor.nombre if emprendedor.present?
  end

  def tiene_pedidos_recomendados
    if current_user.present?
      usuario = ConfigUser.find_by(user_id: current_user.id)
      pedidos_recomendados = Pedido.find_by(id_embajador: usuario.id)
      if pedidos_recomendados.present?
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
