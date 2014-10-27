Rails.application.configure do
  config.action_mailer.default_options = {
      from: 'photoblogapp@gmail.com'
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      user_name:            'photoblogapp@gmail.com',
      password:             ENV['GMAIL_PWD'],
      authentication:       'plain',
      enable_starttls_auto: true
  }
end