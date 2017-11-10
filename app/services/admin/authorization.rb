class Admin::Authorization < Service

  def call(args)
    username = args[:username]
    password = args[:password]

    password_tool = AdminPasswordTool.new

    if password_tool.test_password?(username, password)
      result.success!
    else
      result.failed!
    end

    result
  end
end
