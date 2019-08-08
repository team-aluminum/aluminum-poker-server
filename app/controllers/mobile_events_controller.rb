class MobileEventsController < ApplicationController

  before_action :set_user

  def mobile_user
    if mobile_user = MobileUser.find_by(user_id: @user.id)
      return render json: { mobile_user: mobile_user, status: 'already_created' }
    end
    mobile_user = MobileUser.create!(user_id: @user.id)
    render json: { mobile_user: mobile_user }, status: 201
  end

  def read_card
    valid = set_card
    return render json: { message: 'invalid_card' }, status: 400 if !valid

    if @user.room.nil?
      @user.add_key("#{@suit}#{@number}")
      return render json: { message: 'ok' }
    end
  end

  private

    def set_user
      @user = User.find_by!(code: params[:user_code])
    end

    def set_card
      suit = params[:suit].to_s
      if suit && %w(s h d c).include?(suit[0])
        @suit = suit[0]
      end
      number = params[:number].to_i
      if number && 1 <= number && number <= 13
        @number = number
      end
      !!(@suit && @number)
    end
end
