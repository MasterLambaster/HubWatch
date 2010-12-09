require 'time'
require 'rack/utils'
require 'rack/mime'
require 'net/http'

class App < Rack::File
  def call(env)
    if env["PATH_INFO"] =~ /api/
      resp  = Net::HTTP.get('github.com', env["PATH_INFO"])
      [200,
        {
          "Content-Type" => 'application/json',
          "Content-Length" => resp.size.to_s
        }, 
      resp]
    else
      env["PATH_INFO"] = "/index.html" if env["PATH_INFO"] == '/'
      super(env)
    end
  end
end
run App.new('.')

