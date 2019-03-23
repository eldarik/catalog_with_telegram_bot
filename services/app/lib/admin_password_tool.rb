class AdminPasswordTool
  def initialize
    @pepper = Rails.application.secrets.admin_user_pepper
  end

  def password_digest(username, password)
    compute_hash(
      [
        compute_hash(password),
        compute_hash(username),
        compute_hash(@pepper)
      ].join
    )
  end

  def test_password?(username, password)
    password_digest(username, password) == Rails.application.secrets.admin_password_digest
  end

  def compute_hash(string)
    Digest::SHA512.new.hexdigest(string)
  end
end
