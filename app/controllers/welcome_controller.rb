class WelcomeController < ApplicationController
  skip_before_action :logged_user, only: [:index]
  before_action :if_logged

  def index
  end

  private

    def if_logged
      if current_user
        redirect_to tasks_url
      end
    end
end