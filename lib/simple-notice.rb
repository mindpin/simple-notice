require 'sidekiq'
require 'sidekiq/limit_fetch'
require 'simple_notice/notice'
require 'simple_notice/callbacks_methods'
require 'simple_notice/sidekiq_worker'

module SimpleNotice
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
        # record_notice :scene => :questions,
        #       :callbacks => [ :create ]
      def record_notice(options)
        scene     = options[:scene]     || self.name.downcase.pluralize
        callbacks = options[:callbacks] || [ :create, :update ]
        
        _add_record_notice_options({
          :scene                 => scene,
          :callbacks             => callbacks,
          :users                 => options[:users],
          :set_notice_data       => options[:set_notice_data],
          :before_record_notice  => options[:before_record_notice],
          :after_record_notice   => options[:after_record_notice],
          :async                 => !!options[:async]
        })

        self.send(:include, CallbacksMethods)

        self.send(:after_create, :set_notice_on_create)
        self.send(:after_update, :set_notice_on_update)
      end

      def record_notice_options
        @@record_notice_options || []
      end

      private
      def _add_record_notice_options(options)
        @@record_notice_options ||= []
        @@record_notice_options << options
      end
    end
  end
end

ActiveRecord::Base.send :include, SimpleNotice::Base