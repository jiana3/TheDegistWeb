class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user,  only: [:show, :edit, :update, :destroy]

  def new
  @user = User.new
  end
 # GET /posts/1
  # GET /posts/1.json
  def show

  end
  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
   @user.updated_at = Time.now  
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def subscription
  @user = User.new
  @user = User.find(params[:id])
  param_subscriber = params[:is_subscriber]
  if param_subscriber == "true"
   notice = 'Hooray!! You are subscribed! You will not regret!'
  else
   notice ='You are no longer subscribed! You can come back at any time!!' 
  end
  if @user.update_attribute(:is_subscriber,params[:is_subscriber])
   respond_to do |format|
     flash[:notice] =  notice          
     format.html {redirect_to articles_path}
   end 
  end
  end
  def create    
    @user = User.new(user_params)
    @user.created_at = Time.now    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created!'
        format.html { redirect_to action: "new", notice: '' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end    
  end

  def edit
  end

  def destroy
      @user.destroy
      respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    if @user != current_user
      respond_to do |format|
      format.html { render '/sessions/unauth', status: 403 }
     #format.json { redirect_to articles_path, status: 403 }
      end
    end
  end
      # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
     params.require(:user).permit(:first_name,:last_name,:email, :username, :password, :password_confirmation, :tag_list, :bio)
  end
end
