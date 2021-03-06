class CarPermitApplicationsController < ApplicationController
	before_action :authenticate_user!

	def new
		@application = CarPermitApplication.new
	end	

	def create
		@application = current_user.car_permit_applications.new(car_permit_application_params)

		if @application.save
			send_email!
			flash[:success] = "車両通勤申請が完了いたしました。"
			redirect_to staff_index_path
		else
			flash[:alert] = @application.errors.full_messages[0]
			render :new
		end
	end

	private

	def send_email!
		UserMailer.new_car_permit_application(application: @application, user: current_user).deliver_now
	end

	def car_permit_application_params
		params.require(:car_permit_application).permit(:license, :insurance_papers, :inspection_certificate)
	end
end
