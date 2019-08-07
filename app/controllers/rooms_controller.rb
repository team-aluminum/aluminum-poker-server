class RoomsController < ApplicationController

  def create
    room = Room.create!
    user = User.create!(room_id: room.id, hosting: true)
    render json: { room: room, user: user }, status: 201
  end
end
