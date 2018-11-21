require_relative '../application'
require_relative 'app_logger'

$environment = 'test'

def app
  Application.instance
end

app.run!

# AppLogger.new(logenv: File.expand_path('log/app.log', __FILE__))
