class UsersController < ApplicationController
  def mentionable
    query = params[:query].to_s.downcase
    users = User.where("LOWER(username) LIKE ?", "%#{query}%").limit(5)
    render json: users.select(:id, :username)
  end
  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:username, :date_of_birth, :avatar)
  end
end
