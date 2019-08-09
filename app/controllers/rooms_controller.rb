class RoomsController < ApplicationController

  def create
    room = Room.create!
    user = User.create!(room_id: room.id, hosting: true)
    render json: { room: room, user: user }, status: 201
  end

  def setup
    user = User.find_by!(code: params[:user_code])
    room = user.room
    return render json: { message: 'room_not_found' }, status: 400 if room.nil?
    room.users.sample.update(button: true)
    room.users.update(chips: 100)
    room.drawing!
    render json: { message: 'ok' }
  end
end
