class Ohia < Sinatra::Base
  Rack::Session::Pool

  # http://www.sinatrarb.com/faq.html#auth
  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && 
      @auth.credentials && @auth.credentials == [ ENV['USER'], ENV['PASSWORD'] ]
    end
  end

  get '/' do
    protected!

    erb :index
  end
end