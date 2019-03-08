# frozen_string_literal: true

module Authegy
  module Authorization
    class AccessRuleByRole < Rule

      def foreign_key_columns
        [aliased_subquery[:actor_id]]
      end

      def to_active_record_joins
        joins = association_joins_from_reflections reflection_chain
        joins << to_active_record_join
        joins
      end

      def aliased_subquery
        @aliased_subquery ||= generate_subquery
      end

      def to_active_record_join
        primary_key = class_to_join.arel_table[:id]
        foreign_key = aliased_subquery[:resource_id]
        join_condition = aliased_subquery.create_on primary_key.eq(foreign_key)

        aliased_subquery.create_join aliased_subquery,
                                     join_condition,
                                     Arel::Nodes::OuterJoin
      end

      alias to_active_record_joins to_active_record_join

      def requires_join?; true; end

      def self.new_subquery
        ::RoleAssignment.select(:actor_id, :resource_id).joins :role
      end
      delegate :new_subquery, to: :class

      private

      def class_to_join
        @class_to_join ||= \
          if reflection_chain.any?
            reflection_chain.last.options.fetch(:class_name).constantize
          else
            restrictable_class
          end
      end

      def generate_subquery
        # TODO: Add the person_id inside the subquery...
        role_condition = Role.arel_table[:name].in(subjects)

        resource_type_condition = ::RoleAssignment
          .arel_table[:resource_type]
          .eq(class_to_join.name)

        subquery_condition = resource_type_condition.and(role_condition)
        subquery = new_subquery.where(subquery_condition).arel
        subquery_alias_prefix = if (last_reflection = reflection_chain.last)
                                  last_reflection.name.to_s
                                else
                                  class_to_join.name.underscore
                                end
        subquery_alias = '"' + subquery_alias_prefix + '_role_assignments"'

        aliased_subquery = Arel::Nodes::TableAlias
          .new subquery, Arel::Nodes::SqlLiteral.new(subquery_alias)
      end
    end
  end
end
