class MobileEventsController < ApplicationController

  before_action :set_user

  def mobile_user
    if mobile_user = MobileUser.find_by(user_id: @user.id)
      return render json: { error_code: 'already_created' }, status: 409
    end
    mobile_user = MobileUser.create!(user_id: @user.id)
    render json: { message: 'ok' }, status: 201
  end

  def read_card
    valid = set_card
    if !valid
      return render json: {
        error_code: 'invalid_card',
        message: 'Suit or number is invalid format.',
      }, status: 400
    end

    if @user.room.nil?
      @user.add_key("#{@suit}#{@number}")
      return render json: { message: 'ok' }
    end
  end

  def status
    render json: { status: 'read_card' }
  end

  def action
    render json: { status: 'ok' }
  end

  private

    def set_user
      @user = User.find_by!(code: params[:user_code])
    end

    def set_card
      card = params[:card]
      suit = card[0]
      number = card[1..2].to_i
      if suit && %w(s h d c).include?(suit[0])
        @suit = suit
      end
      if number && 1 <= number && number <= 13
        @number = number
      end
      !!(@suit && @number)
    end
end
