require_relative '../application'
$environment = 'development'

def app
  Application.instance
end

app.run!
