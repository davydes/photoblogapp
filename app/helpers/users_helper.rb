module UsersHelper
  def image_avatar_url(user, style = :thumb)
    url_to_attachment(user.avatar, style)
  end

  def masked_user_email(user)
    admin_or_current?(user) ? mail_to(user.email) : user.email.gsub(/.{1,}@/, '***@')
  end
end
