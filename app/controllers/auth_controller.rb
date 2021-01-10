class AuthController < ApplicationController

    # Calling this route will respond with a user and a JWT token if successfully authenticated
    def login
        user = User.find_by(email: params[:email])

        if(!user)
            render json: { error: "No account associated with this email exists" }, status: :unauthorized
        else   
            if user.authenticate(params[:password])
                token = JWT.encode({
                    user_id: user.id,
                    name: user.name,
                }, ENV['SECRET_KEY'])
                render json: {user: user, token: token}
            else
                render json: { message: 'Wrong password'}
            end
        end
    end

    # This route can be called to check the local system for an existing token and therefore return a user
    def auto_login
        if session_user
            render json: session_user
        else
            render json: {message: 'No currently logged in user'}
        end
    end

end