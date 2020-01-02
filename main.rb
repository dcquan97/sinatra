require 'sinatra'

  get '/about' do
    'A little about me.'
  end

  get '/hello/:name/:city' do
    "Hey there #{params[:name].upcase} from #{params[:city].upcase}."
  end

  get '/form' do
    erb :form
  end

  post '/form' do
    if params[:Email] == 'dcq@gmail.com' && params[:Password] == '123123'
      erb :home
    else
      erb :form
    end
  end

  post '/home' do
    erb :form
  end

  not_found do
    status 404
    'not found'
  end
