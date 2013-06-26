simple-notice
=============

用来包装通知功能的GEM



引入 gem
=========
```
gem 'simple-notice',
    :git => 'git://github.com/mindpin/simple-notice',
    :tag => '0.0.1'
```


增加 migration
==============
```
    create_table :notices do |t|
      t.string  :what
      t.string  :scene
      t.integer :user_id
      t.text    :model_id
      t.string  :model_type
      t.text    :data
      t.boolean :is_read, :default => false
      t.timestamps
    end
```


给模型增加声明
==============
```
class Question < ActiveRecord::Base
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
end
```

查询
=====
```
notices = SimpleNotice::Notice.by_user(user)
notice = notices.first

notice.user
notice.scene
notice.model
notice.what
notice.data
```
