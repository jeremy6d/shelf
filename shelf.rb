require 'rack'


Dir.glob(File.expand_path("../use_cases/*.rb", __FILE__)).each do |file|
  puts "requiring #{file}"
  require file
end

use Rack::Static, 
  :urls => ["/stylesheets", "/images", "/javascripts"],
  :root => "static"

run ->(env) {
  use_case = ServePage.new(env)
  puts "here"
  use_case.respond
}


# class Shelf < Cuba; end

# Shelf.use Rack::Session::Cookie, :secret => SecureRandom.hex(64)
# Shelf.use Rack::Protection

# Shelf.define do
#   on get do
#     on root do
#       use_case = ServePage.new("index.html", 60)

#       res.write use_case.response!
#     end

#     on ":path" do |path|
#       ServePage.new(path, :never).response!
#     end
#   end
# end

