class Admin::TokensController < Admin::BaseController
  def index
    @tokens = []
    if ts = params[:token_string]
      l = ts.length
      even_prefix = ts[0..(l - (l % 2))]
      key_prefix, secret_prefix = Token.token_split(even_prefix)

      tok_table = Token.arel_table
      
      @tokens = Token.where(tok_table[:key].matches("#{key_prefix}%"))
    else
      @tokens = Token.order(created_at: :desc).limit(Team.count * Service.count)
    end
  end

  def show
  end
end
