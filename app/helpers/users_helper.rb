module UsersHelper
  def image_avatar_url(user, style = :thumb)
    url_to_attachment(user.avatar, style)
  end

  def masked_user_email(user)
    admin_or_current?(user) ? mail_to(user.email) : user.email.gsub(/.{1,}@/, '***@')
  end

  def birthday(user)
    if user.date_of_birth
      user.date_of_birth.strftime("%d.%m.%Y")
    else
      ''
    end
  end

  def gender(user)
    {
        'f' => t('users.genders.female'),
        'm' => t('users.genders.male')
    }[user.gender]
  end
end
