module ApplicationHelper
  def current_class?(test_path)
    return request.path == test_path ? 'active' : 'asd'
  end
end
