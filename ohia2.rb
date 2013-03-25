class Ohia < Sinatra::Base
  use Rack::Session::Pool

  set :username, ENV['username'] # heroku config
  set :password, ENV['password']

  configure :production do
    require 'rack-ssl-enforcer'
    use Rack::SslEnforcer
  end

  helpers do
    def authenticated?
      session[:authenticated] == true
    end

    def protected!
      redirect '/login' unless authenticated?
    end
  end

  get '/' do
    protected!

    erb :index
  end

  get '/login' do
    erb :login, :layout => :layout_login
  end

  post '/login' do
    params.inspect
    if params['username'] == settings.username &&
       params['password'] == settings.password
      session[:authenticated] = true
      redirect '/'
    else
      session[:message] = "Username or Password incorrect"
      erb :login, :layout => :layout_login
    end
  end

  get '/logout' do
    session[:authenticated] = nil
    redirect '/login'
  end
end