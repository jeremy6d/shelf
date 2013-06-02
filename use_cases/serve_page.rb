# Title: Serve Page
# Primary Actor: Public visitor requesting a page
# Goal: Retrieve a page from the system

require 'moped'

class GetResource
  def initialize rack_env
    puts rack_env.inspect
    @domain = rack_env['HTTP_HOST'].split(":").first
    @path, @mime = rack_env['PATH_INFO'].split(".")
    @mime ||= "html"
  end

  def respond!
    if resource
      [ 200, 
        { "Cache-Control" => "max-age=#{resource['cache_duration']} public",
          "Last-Modified" => Time.now.httpdate,
          "ETag" => "e4gw45hw45hw35" },
        [ resource[@mime] ] ]
    else
      error!
    end
  end

protected
  def error!
    puts "error"
    [ 500, { "Cache-Control" => "no-cache" }, [ "ERROR" ] ]
  end

  def resource
    puts "looking up #{@path}"
    @resource ||= begin
      session = Moped::Session.new(["127.0.0.1:27017"])
      session.use @domain
      session[:resources].find(uri: @path).first
    rescue => e
      false
    end
  end

  # def cache! &block
  #   @headers["Cache-Control"] = case @cache_duration
  #   when :forever
  #     "max-age=31556926 public"
  #   when :never
  #     "no-cache"
  #   else
  #     puts "caching for #{@cache_duration}"
  #     "max-age=#{@cache_duration} public"
  #   end

  #   res.headers["Last-Modified"] = Time.now.httpdate
  #   response = yield
  #   res.headers["ETag"] = "e4gw45hw45hw35"
  # end
end