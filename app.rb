require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

set :server, 'thin'
set :sockets, []

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id:session[:user])
  end
end

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  user=User.find_by(email:params[:email])
   if user&&user.authenticate(params[:password])
    session[:user]=user.id
    redirect '/'
  else
    redirect '/sign_in'
  end
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user=User.create(
  name:params[:name],
  email:params[:email],
  password:params[:password],
  )

  session[:user]=user.id
  redirect '/community'
end

get '/community' do
   if current_user.nil?
    redirect '/sign_in'
   end
  erb :community
end

post '/community' do
  if current_user.nil?
    redirect '/sign_in'
  else
    Community.all.each do |community|
      sym="community#{community.id}".to_sym
      if !params[sym].nil?
      UserCommunity.create(
        user_id:current_user.id,
        community_id:community.id
        )
      end
    end
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/websocket' do
  if request.websocket?
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        settings.sockets.each do |s|
          s.send(msg)
        end
      end
      ws.onclose do
        settings.sockets.delete(ws)
      end
    end
  end
end