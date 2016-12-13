class Registrations::StepsController < ApplicationController
	RESERVATION_PAGE = "5"

	def show
		@user = session[:user] || User.new						
		@user.valid? if session[:sent_registration_form]

		if params[:id] == RESERVATION_PAGE
			@reservation = session[:reservation] || Reservation.new 
		end
	end
end
