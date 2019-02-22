require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

Dotenv.load
Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
end

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
  if !params[:profile_url].nil?
    @tempfile = params[:profile_url][:tempfile]
    uploads ={}
    uploads[:fish] = Cloudinary::Uploader.upload(@tempfile.path)
    @url = uploads[:fish]['url']
  end
  user=User.create(
  name:params[:name],
  profile_url:@url,
  email:params[:email],
  password:params[:password],
  )

  session[:user]=user.id
  redirect '/community'
end

get '/sign_out' do
 session[:user]=nil
 redirect '/sign_in'
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

get '/home' do
  if current_user.nil?
    redirect '/sign_in'
  else
    erb :home
  end
end

post '/home' do#プロフィールの一言の更新
  user=User.find_by(id:session[:user])
  user.profile=params[:profile]
  user.save
  redirect '/home'
end

get '/edit' do
  erb :edit
end

post '/edit' do
  if !current_user.nil?
    user=User.find_by(id:session[:user])
    user.name=params[:name]
    user.email=params[:email]
    if !params[:profile_url].nil?
      @tempfile = params[:profile_url][:tempfile]
      uploads ={}
      uploads[:fish] = Cloudinary::Uploader.upload(@tempfile.path)
      @url = uploads[:fish]['url']
      user.profile_url=@url
    end
    user.save
    redirect '/home'
  else
    redirect '/sign_in'
  end
end

get '/' do
  erb :index
end

get '/make' do
  if current_user.nil?
      redirect '/sign_in'
  end
  max=User.count
  teamNum=10#1チームの人数
  @@members=(0..max).to_a.shuffle[0..(teamNum-2)]
  erb :make
end

post '/make' do
  team=Team.create()
  @@members.each do |member|
    if (user=User.find_by(id:member) and member!=current_user.id)
      UserTeam.create(user_id:member,team_id:team.id)
    end
  end
  UserTeam.create(user_id:current_user.id,team_id:team.id)
  redirect "/team/#{team.id}"
end

get '/team/:id' do
  if current_user.nil?
    redirect '/sign_in'
  end
  if UserTeam.find_by(user_id:current_user.id,team_id:params[:id])
    erb :team
  else
    redirect '/'
  end
end

post '/team/:id' do
  team=Team.find_by(id:params[:id])
  team.name=params[:name]
  team.save
  redirect "/team/#{params[:id]}"
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