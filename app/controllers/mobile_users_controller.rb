class MobileUsersController < ApplicationController

  def create
    user = User.find_by!(code: params[:user_code])
    if mobile_user = MobileUser.find_by(user_id: user.id)
      return render json: { mobile_user: mobile_user, status: 'already_created' }
    end
    mobile_user = MobileUser.create!(user_id: user.id)
    render json: { mobile_user: mobile_user }, status: 201
  end

  def destroy
    user = User.find_by!(code: params[:user_code])
    if mobile_user = MobileUser.find_by(user_id: user.id)
      mobile_user.destroy!
      return render json: { status: 'deleted' }
    end
    render json: { status: 'not_found' }, status: 404
  end
end
