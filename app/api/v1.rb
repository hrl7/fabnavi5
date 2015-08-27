class V1 < Grape::API
  helpers do
    def authenticate_error!
      h = {'Access-Control-Allow-Origin' => "*",
           'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")}
      error!('Please signin first.', 401, h)
    end

    def authenticate_user!
      uid = request.headers['Uid']
      token = request.headers['Access-Token']
      client = request.headers['Client']
      @user = User.find_by_uid(uid)

      unless @user && @user.valid_token?(token, client)
        authenticate_error!
      end
    end

  end
  mount V1::ProjectsAPI
  mount V1::UsersAPI
end