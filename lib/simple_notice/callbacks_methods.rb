module SimpleNotice
  module CallbacksMethods
    def set_notice_on_create
      __set_notice_on_commit(:create)
    end

    def set_notice_on_update
      __set_notice_on_commit(:update)
    end

    def __set_notice_on_commit(callback_name)
      self.class.record_notice_options.each_with_index do |options,index|
        if options[:callbacks].include?(callback_name)
          proc = options[:before_record_notice]
          if proc.is_a?(Proc)
            bool = proc.call(self, callback_name)
            if bool
              __set_notice_on_commit_by_options(callback_name, index, options[:async])
            end
          end
        end
      end
    end

    def __set_notice_on_commit_by_options(callback_name, options_index, async)
      model_name = self.class.to_s
      model_id   = self.id
      if async
        SidekiqWorker.perform_async(model_name, model_id, callback_name, options_index)
      else
        SidekiqWorker.new.perform(model_name, model_id, callback_name, options_index)
      end
    end

  end
end