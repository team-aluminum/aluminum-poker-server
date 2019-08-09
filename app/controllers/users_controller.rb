class UsersController < ApplicationController

  before_action :set_user, only: [:update, :show]

  def create
    user = User.create!
    render json: { user: user }, status: 201
  end

  def update
    @user.update(update_params)
    render json: { user: @user }
  end

  def show
    mobile_user = @user.mobile_user
    room = @user.room
    opposite_user = room ? room.users.where.not(id: @user.id).first : nil

    if room.nil? || room.preparing?
      keys = ""
      keys = room ? room.keys : @user.keys
      return render json: {
        keys: keys,
        mobile_user: mobile_user,
        opposite_user: opposite_user,
        status: 'preparing',
        hosting: @user.hosting,
      }
    else
      render json: {
        room: room,
        user: @user.serialize,
        mobile_user: mobile_user,
        opposite_user: opposite_user.serialize,
        status: room.status,
      }
    end
  end

  private

    def set_user
      @user = User.find_by!(code: params[:code])
    end

    def update_params
      params.permit(:peer_id)
    end
end
