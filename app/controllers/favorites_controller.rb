class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    flash[:sucess] = 'micropostをお気に入りにしました。'
    redirect_to controller: 'users', action: 'index'
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = 'micropostを削除しました。'
    redirect_to controller: 'users', action: 'index'
  end
end
