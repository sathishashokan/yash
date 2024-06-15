class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    def create
        if params[:email] == nil || params[:name] == nil
            return render(json: {error: "Please provide both name and email."}, status: 422)
        end
        if User.where(email: params[:email]).any?
            render(json: {error: "User with this email already exist"}, status: 401)
        else
            user = User.create(name: params[:name], email: params[:email])
            if user.valid?
                render(json: {message: "New user successfully Created!"}, status: 201)
            else
                render(json: {error: user.errors.full_messages}, status: 422)
            end
        end
    end

    def update
        user = User.find_by(id: params[:id])

        if user.nil?
            return render(json: {error: "User not found. Please provide valid data."}, status: 422)
        end

        unless valid_email?(params[:email])
            return render(json: {error: "Please provide valid email."}, status: 422)
        end

        if user.update(name: params[:name], email: params[:email])

            render(json: {message: "User successfully updated!"}, status: 200)
        else
            render(json: {error: user.errors.full_messages}, status: 422)
        end
    end

    private

    def valid_email?(email)
        email =~ VALID_EMAIL_REGEX
    end
end
