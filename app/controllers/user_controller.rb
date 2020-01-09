class UsersController < ApplicationController

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
    user = Account.find_by(email: params[:email])
    if user && user.password == params[:password]
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
      # binding.pry
      # from = SendGrid::Email.new(email: "emres@framgia.com")
      # to = SendGrid::Email.new(email: user.email)

      # #TODO setting content full later
      # content = SendGrid::Content.new(type: "text/plain", value: content_value)
      # mail = SendGrid::Mail.new(from, "subject", to, "content")


      # sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
      # response = sg.client.mail._("send").post(request_body: mail.to_json)

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
    @user = Account.find params[:id]
    erb :edit
  end

  put "/users/:id" do
    @user = Account.find params[:id]

    if @user.password == params[:current_password]
       @user.update_attributes(password: params[:new_password])
      redirect "/"
    else
      erb :edit
    end
  end

  delete "/users/:id" do
    Account.destroy params[:id]
    session.clear
    redirect "/"
  end

  not_found do
    status 404
    'not found'
  end
end
