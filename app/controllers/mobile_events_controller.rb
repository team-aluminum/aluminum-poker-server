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
    room = @user.room

    if !room.drawing?
      return render json: { error_code: 'not_time_to_read_card' }, status: 400
    end
    if @user.room_cards.size >= 2
      return render json: { error_code: 'too_much_cards' }, status: 400
    end

    if RoomCard.find_by(room_id: @user.room_id, suit: @suit, number: @number)
      return render json: { error_code: 'duplicate' }, status: 400
    end
    RoomCard.create(
      room_id: @user.room_id,
      user_id: @user.id,
      card_type: :user,
      suit: @suit,
      number: @number,
    )
    room.preflopen if room.users.all? { |u| u.room_cards.size == 2 }
    render json: { message: 'ok' }
  end

  def status
    room = @user.room
    return render json: {}, status: 400 if room.nil?
    return render json: { status: 'read_card' } if room.drawing?
    return render json: { status: 'waiting' } if !@user.active

    opposite_user = room.opposite_user(@user)

    limp_label = @user.betting < opposite_user.betting ? 'call' : 'check'
    call_amount = limp_label == 'call' ? opposite_user.betting - @user.betting : nil

    render json: {
      status: 'active',
      limp_label: limp_label,
      call_amount: call_amount,
      min_raise_amount: 10,
      max_raise_amount: 50,
    }
  end

  def action
    if !['check', 'call', 'fold', 'raise'].include?(params[:type])
      return render json: { error_code: 'invalid_action' }
    elsif params[:type] == 'raise' && params[:amount].nil?
      return render json: { error_code: 'raise_amount_required' } 
    end

    room = @user.room
    opposite_user = room.opposite_user(@user)

    if params[:type] == 'check'
      @user.update(limp: true, active: false)
      opposite_user.update(active: true)
    end
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
