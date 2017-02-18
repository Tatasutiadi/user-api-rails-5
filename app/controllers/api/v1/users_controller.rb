class Api::V1::UsersController < ApplicationController
  respond_to :json
  skip_before_filter  :verify_authenticity_token
  before_filter :restrict_access

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end

  def create
    users = User.new(user_param)
    if users.save
      render json: users , status: 201
    else
      render json: { errors: users.errors},status: 422
    end
  end

  def update
    users = User.find(params[:id])
    if users.update(user_param)
      render json: users , status: 200
    else
      render json: { errors: users.errors},status: 422
    end
  end

  def destroy
    users = User.find(params[:id])
    users.destroy
    head 204
  end

  private

  def user_param
    params.required(:user).permit(:email, :password, :password_confirmation)
  end

  def restrict_access
    api_key = ApiKey.find_by_access_token(params[:token])
    head :unauthorized unless api_key
    # # with header
    # authenticate_or_request_with_http_token do |token, options|
    #   #curl localhost:3000/api/v1/users/1 -H 'Authorization: Token token="c07f3eb6844f82302168587926827"'
    #   # Compare the tokens in a time-constant manner, to mitigate
    #   # timing attacks.
    #   ApiKey.exists?(access_token: token)
    # end
    # #end header
  end

end
