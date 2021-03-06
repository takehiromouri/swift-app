require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  describe "POST #create" do
    context "User is signed in " do
      context "attributes are valid" do
        it "creates a new reservation" do
          user = FactoryGirl.create(:user)

          sign_in user

          expect{
            post :create, reservation: FactoryGirl.attributes_for(:reservation)
          }.to change(Reservation, :count).by(1)
        end

        it "sends an email to the admin" do
          user = FactoryGirl.create(:user)
          mock_reservation_made_email = double("mock_reservation_made_email")
          allow(UserMailer).to receive(:reservation_made).and_return(mock_reservation_made_email)
          allow(mock_reservation_made_email).to receive(:deliver_now)

          sign_in user
          post :create, reservation: FactoryGirl.attributes_for(:reservation)

          expect(UserMailer).to have_received(:reservation_made)
          expect(mock_reservation_made_email).to have_received(:deliver_now)
        end
      end

      context "attributes are not valid" do
        it "does not create a new reservation" do
          user = FactoryGirl.create(:user)

          sign_in user

          expect{
            post :create, reservation: FactoryGirl.attributes_for(:reservation, date_1: nil)
          }.to change(Reservation, :count).by(0)
          expect(response).to render_template :new
        end
      end
    end

    context "User is not signed in" do
      it "redirects the user to sign in page" do
          post :create, reservation: FactoryGirl.attributes_for(:reservation)
          expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
