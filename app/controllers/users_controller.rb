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

    if room.nil? || room.preparing
      keys = ""
      keys = room ? room.keys : @user.keys
      return render json: {
        opposite_user: opposite_user,
        keys: keys,
        mobile_user: mobile_user,
        preparing: true,
        hosting: @user.hosting,
      }
    else
      render json: {
        opposite_user: opposite_user,
        room: room,
        user: @user,
        mobile_user: mobile_user,
        preparing: false
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
