module Docs
  class Rails
    class EntriesFilter < Docs::Rdoc::EntriesFilter
      TYPE_BY_NAME_MATCHES = {
        /Assertions|::Test|Fixture/                          => 'Testing',
        /\AActiveRecord.+Assoc/                              => 'ActiveRecord/Associations',
        /\AActiveRecord.+Attribute/                          => 'ActiveRecord/Attributes',
        /\AActiveRecord.+(Migration|Schema|Adapters::Table)/ => 'ActiveRecord/Migrations',
        /\AActiveSupport.+(Subscriber|Notifications)/        => 'ActiveSupport/Instrumentation',
        /\A(False|Nil|True)Class/                            => 'Boolean' }

      TYPE_BY_NAME_STARTS_WITH = {
        'ActionDispatch::Integration' => 'Testing',
        'ActionDispatch::Routing'     => 'ActionDispatch/Routing',
        'ActionView::Helpers'         => 'ActionView/Helpers',
        'ActiveModel::Errors'         => 'ActiveModel/Validation',
        'ActiveModel::Valid'          => 'ActiveModel/Validation',
        'ActiveRecord::Batches'       => 'ActiveModel/Query',
        'ActiveRecord::Calculations'  => 'ActiveModel/Query',
        'ActiveRecord::Connection'    => 'ActiveModel/Connection',
        'ActiveRecord::FinderMethods' => 'ActiveModel/Query',
        'ActiveRecord::Query'         => 'ActiveModel/Query',
        'ActiveRecord::Relation'      => 'ActiveModel/Relation',
        'ActiveRecord::Result'        => 'ActiveModel/Connection',
        'ActiveRecord::Scoping'       => 'ActiveModel/Query',
        'ActiveRecord::SpawnMethods'  => 'ActiveModel/Query',
        'ActiveSupport::Cach'         => 'ActiveSupport/Caching',
        'ActiveSupport::Hash'         => 'ActiveSupport/Hash',
        'ActiveSupport::Inflector'    => 'ActiveSupport/Inflector',
        'ActiveSupport::Ordered'      => 'ActiveSupport/Hash',
        'ActiveSupport::Time'         => 'ActiveSupport/TimeZones',
        'Rails::Application'          => 'Rails/Application',
        'Rails::Engine'               => 'Rails/Engine',
        'Rails::Railtie'              => 'Rails/Railtie' }

      def get_name
        name = super
        name.sub! 'HashWithIndifferentAccess::HashWithIndifferentAccess', 'HashWithIndifferentAccess'
        name
      end

      def get_type
        parent = at_css('.meta-parent').try(:content).to_s

        if [name, parent].any? { |str| str.end_with?('Error') || str.end_with?('Exception') }
          return 'Errors'
        end

        TYPE_BY_NAME_MATCHES.each_pair do |key, value|
          return value if name =~ key
        end

        TYPE_BY_NAME_STARTS_WITH.each_pair do |key, value|
          return value if name.start_with?(key)
        end

        super
      end

      def include_default_entry?
        super && !skip?
      end

      def additional_entries
        skip? ? [] : super
      end

      def skip?
        @skip ||= !css('p').any? { |node| node.content.present? }
      end
    end
  end
end
