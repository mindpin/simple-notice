module SimpleNotice
  class Notice < ActiveRecord::Base
    attr_accessible :user, :scene, :model, :what, :data

    validates :user, :scene, :model, :what, :presence => true

    belongs_to :user, :class_name => 'User', :foreign_key => :user_id
    belongs_to :model, :polymorphic => true

    scope :by_user,  lambda {|user|  { :conditions => ['user_id = ?', user.id] }  }

    default_scope :order => 'id desc'

    validate :validate_repeat_notice
    def validate_repeat_notice
      newest_notice = SimpleNotice::Notice.by_user(self.user).first
      return true if newest_notice.blank?

      bool_1 = (newest_notice.user == self.user)
      bool_2 = (newest_notice.scene == self.scene)
      bool_3 = (newest_notice.model == self.model)
      bool_4 = (newest_notice.what == self.what)
      bool_5 = (newest_notice.data.to_s == self.data.to_s)

      if bool_1 && bool_2 && bool_3 && bool_4 && bool_5
        errors.add(:base,'重复的 notice')
      end

    end
  end
end