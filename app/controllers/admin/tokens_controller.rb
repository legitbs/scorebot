class Admin::TokensController < Admin::BaseController
  def index
    @tokens = []
    if ts = params[:token_string]
      @tokens = Token.where_prefixed_by ts
    else
      @tokens = Token.order(created_at: :desc).limit(Team.count * Service.count)
    end
  end

  def show
    @token = Token.find params[:id]
  end
end
