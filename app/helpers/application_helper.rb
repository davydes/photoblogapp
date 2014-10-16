module ApplicationHelper

  def mobile_user_agent?
    request.env["HTTP_USER_AGENT"].try :match, /(iphone|ipod|android)/i
  end

  def bootstrap_class_for (flash_type)
    {
      'success' => 'alert-success',
      'error' => 'alert-danger',
      'alert' => 'alert-warning',
      'notice' => 'alert-info'
    }[flash_type] || flash_type.to_s
  end

end
