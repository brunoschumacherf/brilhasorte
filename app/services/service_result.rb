class ServiceResult
  attr_reader :payload, :errors

  def initialize(success:, payload: nil, errors: [])
    @success = success
    @payload = payload
    @errors = errors
  end

  def success?
    @success
  end
end
