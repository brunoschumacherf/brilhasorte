class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end


  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up).tap do |params|
      params[:referral_code] = params[:referral_code]
    end
  end

  def build_resource(hash)
    referral_code = hash.delete(:referral_code)
    super(hash).tap do |user|
      if referral_code.present?
        referrer = User.find_by(referral_code: referral_code.upcase)
        user.referrer = referrer if referrer
      end
    end
  end
end
