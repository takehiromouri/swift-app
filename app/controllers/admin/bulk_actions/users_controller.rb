require 'csv'

class Admin::BulkActions::UsersController < ApplicationController
  before_action :authenticate_admin_user!

  def new
  end

  def create
    users = users_params[:text]

    new_users = []
    current_date = nil

    if users_params[:file]
      CSV.parse(users_params[:file].read.force_encoding("SJIS").encode("utf-8"), headers: true) do |row|
        next if encode_and_scrub(row[4]).nil?
        next if User.where("unique_id = ? OR email = ?", encode_and_scrub(row[0]), encode_and_scrub(row[4])).exists?

        user = User.new
        user.unique_id = encode_and_scrub(row[0])
        user.last_name = encode_and_scrub(row[1]) ? encode_and_scrub(row[1]).split('　').first : nil
        user.first_name = encode_and_scrub(row[1]) ? encode_and_scrub(row[1]).split('　').last : nil
        user.last_name_katakana = encode_and_scrub(row[2]) ? encode_and_scrub(row[2]).split(' ').first : nil
        user.first_name_katakana = encode_and_scrub(row[2]) ? encode_and_scrub(row[2]).split(' ').last : nil
        user.gender = row[3] == 'TRUE' ? :女性 : :男性
        user.email = encode_and_scrub(row[4])
        user.email_confirmation = encode_and_scrub(row[4])
        user.phone = encode_and_scrub(row[5])

        begin
          birthday_str = encode_and_scrub(row[6]).split('/')
          user.birthday = Date.new(birthday_str[0].to_i, birthday_str[1].to_i, birthday_str[2].to_i)
        rescue
          user.birthday = nil
        end

        new_users << user if user.save
      end
    else
      users_string_arr = users.split(/\r\n/)
      users_string_arr.each_with_index do |line,i|
        if line.match(/\b\d{5}\b/)
          user = User.new(unique_id: line.match(/\b\d{5}\b/))
          user.last_name = users_string_arr[i+1].split('　').first
          user.first_name = users_string_arr[i+1].split('　').last
          user.last_name_katakana = users_string_arr[i+2].split(' ').first
          user.first_name_katakana = users_string_arr[i+2].split(' ').last
          user.gender = users_string_arr[i+3] == 'TRUE' ? :女性 : :男性
          user.email = users_string_arr[i+4]
          user.email_confirmation = users_string_arr[i+4]
          birthday_str = users_string_arr[i+5].split('/')
          user.birthday = Date.new(birthday_str[0].to_i, birthday_str[1].to_i, birthday_str[2].to_i)

          new_users << user if user.save
        end
      end
    end

    flash[:notice] = "#{new_users.length}件のユーザーを作成しました。"
    redirect_to admin_bulk_actions_users_path
  end

  private

  def users_params
    params.require(:users).permit(:text, :file)
  end

  def find_string_after(string, marker)
    string.split(marker).last
  end

  def encode_and_scrub(string)
    return nil unless string

    string.force_encoding('UTF-8').scrub
  end
end
