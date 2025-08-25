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
        errors: resource.errors.to_hash(full_messages: true)
      }, status: :unprocessable_entity
    end
  end


  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :full_name, :cpf, :phone_number, :birth_date, :referral_code)
  end
  # ----------------------------

  def build_resource(hash)
    referral_code = hash.delete(:referral_code)
    super(hash).tap do |user|
      if referral_code.present?
        referrer = User.find_by(referral_code: referral_code.upcase)
        user.referred_by = referrer if referrer
      end
    end
  end
end
