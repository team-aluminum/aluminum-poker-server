class RoomsController < ApplicationController

  def create
    room = Room.create!(code: params[:room_code])
    user = User.create!(room_id: room.id)
    render json: {}, status: 201
  end

  def show
    room = Room.find_by!(code: params[:code])
    render json: { room: room }
  end
end
