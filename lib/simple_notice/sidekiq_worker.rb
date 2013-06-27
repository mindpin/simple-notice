module SimpleNotice
  class SidekiqWorker
    include Sidekiq::Worker
    sidekiq_options :queue => 'simple_notice'
    Sidekiq::Queue['simple_notice'].limit = 1

    def perform(model_name, model_id, callback_name, options_index)
      model = Object.const_get model_name
      model_instance = model.find(model_id)
      options = model_instance.class.record_notice_options[options_index.to_i]
      __set_notice_on_commit_by_options(model_instance, callback_name, options)
    end

    def __set_notice_on_commit_by_options(model_instance, callback_name, options)

      proc = options[:set_notice_data]
      if proc.is_a?(Proc)
        data = proc.call(model_instance, callback_name.to_sym)
      else
        data = nil
      end

      proc = options[:users]
      if proc.is_a?(Proc)
        users = proc.call(model_instance, callback_name.to_sym)
      else
        users = []
      end

      users.each do |user|
        notice = SimpleNotice::Notice.create({
          :user => user,
          :model => model_instance,
          :scene => options[:scene],
          :data => data,
          :what => "#{callback_name}_#{model_instance.class.to_s.underscore}"
        })

        proc = options[:after_record_notice]
        if proc.is_a?(Proc)
          proc.call(model_instance, callback_name.to_sym, notice)
        end
        
      end

    rescue Exception => ex
      p "警告: #{model_instance.class} notice 创建失败"
      puts ex.message
      puts ex.backtrace*"\n"
    end

  end
end