require "administrate/field/base"

class AttachinaryField < Administrate::Field::Base
  def paths
    data.map { |i| i.path }
  end

  def to_s
    ''
  end
end
