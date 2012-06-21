require 'time'
require 'rack/utils'
require 'rack/mime'
require 'net/http'
require 'net/https'
require 'json'
class App < Rack::File
  def call(env)
    if env["PATH_INFO"] =~ /users/

      req = Net::HTTP.new('api.github.com', 443)
      req.use_ssl = true
      # Since github returns 100 watched repost at the most, had to iterate
      # over all pages ;(
      page = 0
      result = []
      begin
        resp = JSON.parse(req.get2(env["PATH_INFO"] + "?per_page=100&page=#{page += 1}").body)
        result.concat(resp) if resp.size > 0
      end while resp.size > 0

      body = result.to_json
      [200,
        {
          "Content-Type" => 'application/json',
          "Content-Length" => body.bytesize.to_s
        },
      [body]]
    else
      env["PATH_INFO"] = "/index.html" if env["PATH_INFO"] == '/'
      super(env)
    end
  end
end
run App.new('.')

