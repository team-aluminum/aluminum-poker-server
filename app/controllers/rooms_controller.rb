class RoomsController < ApplicationController

  def create
    room = Room.create!(code: params[:room_code])
    user = User.create!(room_id: room.id)
    render json: { room: room, user: user }, status: 201
  end

  def show
    room = Room.find_by!(code: params[:code])
    user = User.find_by!(code: params[:user_code])
    mobile_user = MobileUser.find_by(user_id: user.id)
    render json: {
      room: room,
      user: user,
      mobile_user: mobile_user
    }
  end
end
