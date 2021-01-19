IMGKit.configure do |config|
  config.wkhtmltoimage =   (Rails.env.production? ? '/usr/local/bin/wkhtmltoimage' : '/home/deploy/.rbenv/shims/wkhtmltoimage')
end