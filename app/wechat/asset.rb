module Wechat
  module Asset
    include Api
    ##
    # Get the count of a type of asset
    #
    # @return Hash
    # @example
    # {
    #   "voice_count": 1,
    #   "video_count": 2,
    #   "image_count": 3,
    #   "news_count": 4
    # }
    def count(type=nil)
        counts = perform_request 'get', 'material/get_materialcount'
        return counts if type.nil?
        return counts.reject {|k, v| k != "#{type.to_s}_count".to_sym}
    end

    ##
    # Delete the material
    #
    # @return Hash
    def delete(media_id)
      perform_request 'post', 'material/del_material', :json => {:media_id => media_id}
    end

    ##
    # Upload a *TEMPORARY* asset. It will be deleted by Wechat after 3 days
    #
    # @return Hash
    # @example
    # {
    #   "type":"TYPE",
    #   "media_id":"MEDIA_ID",
    #   "created_at":123456789
    # }
    def media_upload(type, path)
      perform_request 'post', 'media/upload', :params => {:type => type}, :form => {:media => HTTP::FormData::File.new(path)}
    end

    ##
    # Download a *TEMPORARY* asset.
    #
  # @return Stream
    def media_get(media_id)
      perform_request 'get', 'media/get', :params => {:media_id => media_id}
    end

    ##
    # Add permanent asset. There are some limits on size of media file.
    # e.g. max picture size is 2M
    def material_add_article()

    end

    ##
    # Check the content size and replace outbound image
    #
    # @return Boolean
    def filter_article_content_and_size(content)
      return false unless content.mb_chars.length < 2 * 1024 * 1024
      content.gsub(/<img src="(.+)">/, )
    end

    ##
    # Store an image in article in qpic server so it wont be filtered out.
    # It's seprate from _media_upload_ because this one doesn't have limit
    #
    # @return Hash
    # @example
    # {
    #   "url":  "http://mmbiz.qpic.cn/mmbiz/gLO17UPS6FS2xsypf378iaNhWacZ1G1UplZYWEYfwvuU6Ont96b1roYs CNFwaRrSaKTPCUdBK9DgEHicsKwWCBRQ/0"
    # }
    def upload_img(path)
      perform_request 'post', 'mediaimg', :form => {:media => HTTP::FormData::File.new(path)}
    end
  end
end
