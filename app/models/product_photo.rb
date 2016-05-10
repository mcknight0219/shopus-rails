class ProductPhoto < ActiveRecord::Base
  belongs_to :good

  before_destroy { |record| Wechat::Asset.delete record.media_id }

  def upload 
    begin
      update_attribute(:media_id, Wechat::Asset.add('image', temp_path)[:media_id])
      update_attribute(:stored_remote, true)
      update_attribute(:temp_path, nil)
    rescue Wechat::Error => e
      logger.debug e.message
    end
  end

  def download
    return nil unless self.stored_remote
    Wechat::Asset.get self.media_id
  end

end
