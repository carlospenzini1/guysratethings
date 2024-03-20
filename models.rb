require './uploaders/image_uploader'
#require './uploaders/listitem_uploader'
require 'carrierwave/orm/activerecord'
class GUser < ActiveRecord::Base
  mount_uploader :profilepic, ImageUploader
  has_many :lists
  has_many :messages, :dependent => :destroy
  has_many :comments
  has_many :followers, :dependent => :destroy
end

class List < ActiveRecord::Base
  has_many :listitems
  belongs_to :guser
  has_many :comments
end

class ListItem < ActiveRecord::Base
  mount_uploader :itemimg, ImageUploader
  belongs_to :list
end

class Comment < ActiveRecord::Base
  belongs_to :guser
  belongs_to :list
end

class Follower < ActiveRecord::Base
  belongs_to :guser
end

class Image < ActiveRecord::Base

end

class ListLike < ActiveRecord::Base
  belongs_to :guser
  belongs_to :list
end

class CommentLike < ActiveRecord::Base
  belongs_to :guser
  belongs_to :comment
end
