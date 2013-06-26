require 'spec_helper'

class Question < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'

  record_notice :scene => 'change_1',
                :callbacks => [ :create ],
                :users => lambda { |question, callback_type|
                  return [question.creator]
                },
                :set_notice_data => lambda {|question, callback_type|
                  return 'change_1_data'
                },
                :before_record_notice => lambda {|question, allback_type|
                  if question.name == 'name_1'
                    return true
                  else
                    return false
                  end
                }

  record_notice :scene => 'change_2',
                :callbacks => [ :update ],
                :users => lambda { |question, callback_type|
                  return [question.creator]
                },
                :set_notice_data => lambda {|question, callback_type|
                  return 'change_2_data'
                },
                :before_record_notice => lambda {|question, allback_type|
                  if question.name == 'name_2'
                    return true
                  else
                    return false
                  end
                }
end

describe 'xx' do
  before{
    @user = User.create!(:name => 'user_1')
  }

  it{
    SimpleNotice::Notice.count.should == 0
  }

  describe 'change_1 change_2 notices' do
    before{
      @question = Question.create!(:name => 'name_1', :creator => @user)
      @question.name = 'name_2'
      @question.save!
    }

    it{
      SimpleNotice::Notice.count.should == 2
    }

    it{
      notice = SimpleNotice::Notice.last
      notice.data.should == 'change_1_data'
      notice.scene.should == 'change_1'
      notice.what.should == 'create_question'
      notice.user.should == @user
      notice.model.should == @question
      notice.is_read.should == false
    }

    it{
      notice = SimpleNotice::Notice.first
      notice.data.should == 'change_2_data'
      notice.scene.should == 'change_2'
      notice.what.should == 'update_question'
      notice.user.should == @user
      notice.model.should == @question
      notice.is_read.should == false
    }
  end

  describe 'no notices' do
    before{
      @question = Question.create!(:name => 'name_11', :creator => @user)
      @question.name = 'name_22'
      @question.save!
    }

    it{
      SimpleNotice::Notice.count.should == 0
    }
  end
end