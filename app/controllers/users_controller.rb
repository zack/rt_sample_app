require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :authenticate,  :except => [:new, :create]
  before_filter :correct_user,  :only => [:edit, :update]
  before_filter :not_signed_in, :only => [:create, :new]
  before_filter :admin_user,    :only => :destroy

  def index
    @title = "All users"
    if params[:search]
      @users = User.find(:all,
                         :conditions => ['name LIKE ?',
                         "%#{params[:search]}%"])
                         .paginate(:page => params[:page])
    else
      @users = User.paginate(:page => params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign Up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "#{user.name} destroyed."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def not_signed_in
    redirect_to(root_path) if signed_in?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
    if current_user[:id].to_i == params[:id].to_i && current_user.admin?
      flash[:notice] = "Can't delete yourself."
      redirect_to(users_path)
    end
  end
end
