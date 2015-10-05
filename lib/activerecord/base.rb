require "activerecord/search/version"
require "active_record"

module ActiveRecord
  class SearchError < ::StandardError
    def message
      "Please set only one the following options: :start_with, :end_with, :anywhere"
    end
  end

  class Base
    class << self
      def inherited(subclass)
        super
        return if subclass.to_s.underscore == "active_record/schema_migration"
        class_eval <<-EOF
          class << #{subclass} 
            attr_reader :search_option, :search_fields

            def search_#{subclass.to_s.underscore}(words, option = nil)
              formatted_words = format_search(words, option)

              search_scope  = []
              search_params = {}
              @search_fields.each do |field|
                search_params[field] = formatted_words
                search_scope << field.to_s + " LIKE :" + field.to_s
              end

              where([search_scope.join(" OR "), search_params])
            end

            def search_fields(fields)
              @search_fields = [fields].flatten
            end
            alias_method :search_field, :search_fields 


            # If options are given, they override the default options behavior
            def format_search(words, option)
              if !option.nil?
                format_with_option(words, option)
              else
                o = @search_option.nil? ? :anywhere : @search_option
                format_with_option(words, o)
              end
            end

            def format_with_option(words, option)
              case option
                when :start_with then words + '%'
                when :end_with   then '%' + words 
                when :anywhere   then '%' + words + '%'
                else
                  raise SearchError
              end
            end

            def search_option(option = :anywhere)
              @search_option = option
            end
          end
        EOF
      end # self.inherited
    end

  end # Base
end # ActiveRecord


