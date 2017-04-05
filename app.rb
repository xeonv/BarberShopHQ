#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

#создаем сущность (entity) ActiveRecord - пространство имен, а Base базовый класс
class Client   < ActiveRecord::Base
	validates :name, presence: true, length: {minimum: 3}
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

before do
	@barbers = Barber.order "created_at DESC"
end

get '/' do
	erb :index
end


get '/visit' do
	@c = Client.new
	erb :visit
end

post '/visit' do

	@c = Client.new params[:client]

	if @c.save
		erb "<h2>Спасибо, вы записались!</h2>"
	else
		@error = @c.errors.full_messages.first
		erb :visit
	end

end

get '/contacts' do
	erb :contacts
end


post '/contacts' do
	text = params[:text]
	email = params[:email]

		if text == ''
				@error = 'Введите текст для отправки. '
				return erb :contacts
			end
	Contact.create :email =>email, :text =>text
	return erb "Спасибо за Ваш отзыв!"
end

get '/barber/:post_id' do
	@barber = Barber.find (params[:post_id])
	erb :barber
end

get '/bookings' do
	@clients = Client.order ('created_at DESC')
	erb :bookings

end

get '/client/:id' do
	@client = Client.find (params[:id])
	erb :client
end
