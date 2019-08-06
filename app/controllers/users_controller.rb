class UsersController < ApplicationController

  def create
    user = User.create!
    render json: { user: user }, status: 201
  end

  def show
    user = User.find_by!(code: params[:code])
    room = user.room
    mobile_user = user.mobile_user
    render json: {
      room: room,
      user: user,
      mobile_user: mobile_user,
    }
  end
end
