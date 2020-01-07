require "sinatra"
require "sinatra/activerecord"
require "./models/note"
require 'pry'

set :database, {adapter: "sqlite3", database: "noteapp.sqlite3"}

enable :sessions
set :sessions, :expire_after => 300

helpers do
  def current_user
    if session[:user_id]
      User.find {users.id == session[:user_id]}
    else
      nil
    end
  end
end

get '/' do
  #binding.pry
  if current_user
    @users = User.all
    erb :home
  else
    redirect "/login"
  end
end

get '/login' do
  if current_user
    @users = User.all
    erb :home
  else
    erb :login
  end
end

get '/home' do
  @users = User.all
  erb :home
end

post '/login' do

 users = User.where(Email: params[:Email], Password: params[:Password])
  if users != nil
    user = users.first
    # response.set_cookie("user_id", value: user.id, expires: Time.now + 60*60*24*365 )
    session["user_id"] = user.id
    @users = User.all
    redirect '/'
  else
    @error = true
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  @user = User.new(Email: params[:email], Password: params[:password])
  @user.save

  redirect '/'
end

post '/logout' do
  session.clear
  # response.set_cookie("user_id", value: "", expires: Time.now - 100 )
  redirect '/'
end

not_found do
  status 404
  'not found'
end
