require "cuba"
require "rack/protection"
require "securerandom"

class Shelf < Cuba; end

Shelf.use Rack::Session::Cookie, :secret => SecureRandom.hex(64)
Shelf.use Rack::Protection

Shelf.define do
  def serve_static file
    path = File.join File.dirname(__FILE__), "static", file
    puts "finding #{path}"
    if File.exists? path
      res.status = 200
      res.write File.read(path)
    else
      error!
    end
  end

  def error!
    puts "error"
    res.status = 500
    res.write "error"
  end

  def cache! obj, &block
    res.headers["Cache-Control"] = case obj
    when :forever
      "max-age=31556926 public"
    when :never
      "no-cache"
    else
      puts "caching for #{obj}"
      "max-age=#{obj} public"
    end

    res.headers["Last-Modified"] = Time.now.httpdate
    response = yield
    res.headers["ETag"] = "e4gw45hw45hw35"
  end

  on get do
    on root do
      cache! 30 do
        serve_static("index.html")
      end
    end

    on ":path" do |path|
      cache! :forever do
        serve_static(path)
      end
    end
  end
end