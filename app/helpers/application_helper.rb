module ApplicationHelper
  def current_class?(test_path)
    return request.path == test_path ? 'active' : 'asd'
  end
  def hide_class_movil?(test_path)
    return request.path == test_path ? 'd-none' : 'd-block d-lg-none'
  end
  def hide_class_web?(test_path)
    return request.path == test_path ? 'd-none' : 'd-none d-lg-block'
  end
end
