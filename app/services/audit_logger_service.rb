class AuditLoggerService
  def call(user:, action:, auditable_object: nil, details: {})
    AuditLog.create!(
      user: user,
      action: action,
      auditable: auditable_object,
      details: details
    )
  end
end
