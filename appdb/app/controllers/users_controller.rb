class UsersController < ApplicationController
  # Controller actions go here
    def index
    @users = User.all
  end
end
