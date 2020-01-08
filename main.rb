require "sinatra"
require "sinatra/activerecord"
require "./models/note"
require 'pry'
require 'devise'

set :database, {adapter: "sqlite3", database: "noteapp.sqlite3"}
set :session_secret, "12332313131"
enable :sessions
set :sessions, expire_after: 900


get '/' do
  @error_message = params[:error]
  if !session[:user_id]
    erb :login
  else
    redirect '/home'
  end
end

get '/login' do
  @error_message = params[:error]
  if !session[:user_id]
    erb :login
  else
    redirect '/home'
  end
end

get '/home' do
  if !session[:user_id]
    redirect '/login'
  else
    erb :home
  end

end

post '/login' do
  user = User.find_by(Email: params[:Email])
  #binding.pry
  if user && user.Password == params[:Password]
    session[:user_id] = user.id
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
  @user = User.create(Email: params[:email], Password: params[:password])
  session[:user_id] = @user.id

  redirect '/'
end

get '/logout' do
  if session[:user_id] != nil
      session.clear
      redirect to '/login'
  else
      redirect to '/'
  end
end
get "/users/:id/edit" do
  @user = User.find params[:id]
  erb :edit
end

put "/users/:id" do
  @user = User.find params[:id]
  if @user.update_attributes(Email: params[:Email], Password: params[:Password])
    redirect "/"
  else
    erb :edit
  end
end

delete "/users/:id" do
  User.destroy params[:id]
  session.clear
  redirect "/"
end


helpers do
  def redirect_if_not_logged_in
    if !logged_in?
      redirect "/login?error=You have to be logged in to do that"
    end
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end



not_found do
  status 404
  'not found'
end
