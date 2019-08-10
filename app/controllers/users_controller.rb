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
    end

    if room.result? && @user.hosting
      u = room.users.find_by(hosting: true)
      o = room.opposite_user(u)
      u.update(result_countdown: u.result_countdown - 1)
      if u.result_countdown <= 0
        room.room_cards.each { |rc| rc.destroy }
        if u.result == 'win' || o.result == 'fold'
          u.update(chips: u.chips + room.pod_chips)
        elsif u.result == 'lose' || u.result == 'fold'
          o.update(chips: o.chips + room.pod_chips)
        else
          u.update(chips: u.chips + room.pod_chips / 2)
          o.update(chips: o.chips + room.pod_chips / 2)
        end
        room.update(pod_chips: 0, status: :drawing)
        room.users.each { |_u|
          _u.update(betting: 0, limp: false, active: false, last_action: nil, button: !_u.button)
        }
      end
    end
    render json: {
      room: room,
      user: @user.serialize,
      mobile_user: mobile_user,
      opposite_user: opposite_user&.serialize,
      status: room.status,
      cards: {
        flop: room.flop_cards,
        turn: room.turn_card,
        river: room.river_card,
      },
    }
  end

  private

    def set_user
      @user = User.find_by!(code: params[:code])
    end

    def update_params
      params.permit(:peer_id)
    end
end
