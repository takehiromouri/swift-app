class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = current_user.reservations.create(reservation_params)
    if @reservation.valid?
      send_new_reservation_email

      redirect_to root_path
    else
      render :new
    end
  end

  private

  def send_new_reservation_email
    UserMailer.reservation_made(user: current_user, reservation: @reservation).deliver_now
  end

  def reservation_params
    params.require(:reservation).permit( :user_id, :date_1, :date_2, :date_3, :date_4, :date_5, :date_6, :date_7)
  end
end