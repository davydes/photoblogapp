module UsersHelper
  def image_avatar_url(user, style = :thumb)
    url_to_attachment(user.avatar, style)
  end
end
