class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: { status: { code: 200, message: 'Se o seu e-mail existir em nossa base de dados, você receberá um link para recuperação de senha.' } }, status: :ok
    else
      render json: { status: { message: "Não foi possível enviar o e-mail de recuperação. #{resource.errors.full_messages.to_sentence}"} }, status: :unprocessable_entity
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: { status: { code: 200, message: 'Sua senha foi alterada com sucesso.' } }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
