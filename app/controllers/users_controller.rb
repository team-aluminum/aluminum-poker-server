class UsersController < ApplicationController

  def create
    user = User.create!
    render json: { user: user }, status: 201
  end
end
