require_relative '../application'
require 'dotenv'

$environment = 'test'

def app
  application = Application.instance
  Dotenv.load(application.root.join(".env"))
  application
end


app.run!
