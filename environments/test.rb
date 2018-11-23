require_relative '../application'

$environment = 'test'

def app
  Application.instance
end

app.run!

# AppLogger.new(logenv: File.expand_path('log/app.log', __FILE__))
