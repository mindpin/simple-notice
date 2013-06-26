module SimpleNotice
  module CallbacksMethods
    def set_notice_on_create
      __set_notice_on_commit(:create)
    end

    def set_notice_on_update
      __set_notice_on_commit(:update)
    end

    def __set_notice_on_commit(callback_name)
      self.class.record_notice_options.each do |options|
        if options[:callbacks].include?(callback_name)
          __set_notice_on_commit_by_options(callback_name, options)
        end
      end
    end

    def __set_notice_on_commit_by_options(callback_name, options)
      proc = options[:before_record_notice]
      if proc.is_a?(Proc)
        bool = proc.call(self, callback_name.to_sym)
        return true if !bool
      end

      proc = options[:set_notice_data]
      if proc.is_a?(Proc)
        data = proc.call(self, callback_name.to_sym)
      else
        data = nil
      end

      proc = options[:users]
      if proc.is_a?(Proc)
        users = proc.call(self, callback_name.to_sym)
      else
        users = []
      end

      users.each do |user|
        notice = SimpleNotice::Notice.create({
          :user => user,
          :model => self,
          :scene => options[:scene],
          :data => data,
          :what => "#{callback_name}_#{self.class.to_s.underscore}"
        })

        proc = options[:after_record_notice]
        if proc.is_a?(Proc)
          proc.call(self, callback_name.to_sym, notice)
        end
        
      end

    rescue Exception => ex
      p "警告: #{self.class} notice 创建失败"
      puts ex.message
      puts ex.backtrace*"\n"
    end



  end
end