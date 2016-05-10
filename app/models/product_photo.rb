class ProductPhoto < ActiveRecord::Base
  belongs_to :good

  def media_id=(value)
    self[:media_id] = value
    self[:stored_remote] = true
    self[:temp_path] = nil
  end

  private
end
