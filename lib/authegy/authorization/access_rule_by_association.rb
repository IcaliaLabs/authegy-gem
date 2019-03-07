# frozen_string_literal: true

module Authegy
  module Authorization
    class AccessRuleByAssociation < Rule
      def to_active_record_joins
        all_but_last = reflection_chain[0..-2]
        return unless all_but_last.any?

        association_joins_from_reflections all_but_last
      end

      def requires_join?
        reflection_chain.count > 1
      end

      def foreign_key_columns
        reflection = reflection_chain.last
        associated_class = reflection.active_record

        foreign_key = reflection
            .options
            .fetch(:foreign_key, "#{reflection.name}_id")
            .to_sym

        [associated_class.arel_table[foreign_key]]
      end
    end
  end
end
