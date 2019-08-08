class UsersController < ApplicationController

  def create
    user = User.create!
    render json: { user: user }, status: 201
  end

  def show
    user = User.find_by!(code: params[:code])
    mobile_user = user.mobile_user
    room = user.room
    users = room ? room.users.where.not(id: user.id) : []

    if room.nil? || room.preparing
      keys = ""
      keys = room ? room.keys : user.keys
      return render json: {
        users: users,
        keys: keys,
        mobile_user: mobile_user,
        preparing: true,
        hosting: user.hosting,
      }
    else
      render json: {
        users: users,
        room: room,
        user: user,
        mobile_user: mobile_user,
        preparing: false
      }
    end
  end
end
