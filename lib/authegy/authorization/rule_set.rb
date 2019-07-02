# frozen_string_literal: true

module Authegy
  module Authorization
    #= Authegy::Authorization::RuleSet
    #
    # Base class used to express authorization rules as a Ruby object, and as a
    # SQL query
    class RuleSet
      include Enumerable

      attr_reader :rules

      def initialize
        @rules = []
      end

      def joins_for(restrictable_class)
        rules_for(restrictable_class)
          .select(&:requires_join?)
          .map(&:to_active_record_joins)
      end

      def conditions_for(restrictable_class, person_id = nil)
        return false unless person_id.present?

        left = if person_id.is_a?(Numeric)
                 Arel::Nodes::SqlLiteral.new(person_id.to_s)
               else
                 Arel::Nodes::SqlLiteral.new("\"#{person_id}\"")
               end

        right = rules_for(restrictable_class)
          .map(&:foreign_key_columns)
          .flatten

        Arel::Nodes::In.new left, right
      end

      def rules_for(restrictable_class)
        rules.select { |rule| rule.restrictable_class == restrictable_class }
      end

      delegate :empty?, :any?, :each, to: :rules

      def add(subjects:, subject_path: nil, restrictable_class: nil)
        path_segments = subject_path.split '.'
        first_segment = path_segments.slice! 0
        resource_class = first_segment.to_s.classify.safe_constantize
        return unless resource_class.present?

        subjects.each do |subject|
          rule_class, reflection_chain = class_and_reflection(
            resource_class,
            subject,
            path_segments.dup
          )

          rule = find_or_create rule_class: rule_class,
                                subject_path: subject_path,
                                reflection_chain: reflection_chain,
                                restrictable_class: restrictable_class

          rule.add_subject subject
        end
      end

      def self.class_and_reflection(resource_class, subject, path_segments)
        reflection_chain = []
        class_to_reflect = resource_class

        while class_to_reflect && (association_name = path_segments.slice! 0) do
          association_reflection = class_to_reflect.reflect_on_association(association_name)
          next unless association_reflection.present?

          reflection_chain << association_reflection
          class_to_reflect = association_reflection.options.fetch(
            :class_name, association_name.singularize.classify
          ).safe_constantize
        end

        return if class_to_reflect.blank?

        subject_reflection = reflect_on_association_to_subject class_to_reflect,
                                                               subject.to_s
        rule_class = subject_reflection ?
          AccessRuleByAssociation :
          AccessRuleByRole

        reflection_chain << subject_reflection if subject_reflection

        [rule_class, reflection_chain]
      end
      delegate :class_and_reflection, to: :class

      def self.reflect_on_association_to_subject(class_to_reflect, subject_name)
        subject_plural = subject_name.pluralize
        subject_singular = subject_name.singularize

        subject_reflection = class_to_reflect
          .reflect_on_association(subject_singular)

        subject_reflection || class_to_reflect
          .reflect_on_association(subject_plural)
      end

      private

      def find_or_create(rule_class:, subject_path: nil, restrictable_class: nil, reflection_chain: [])
        matching_rule = find rule_class: rule_class,
                             subject_path: subject_path,
                             restrictable_class: restrictable_class
        return matching_rule if matching_rule.present?

        new_rule = rule_class.new subject_path: subject_path,
                                  restrictable_class: restrictable_class,
                                  reflection_chain: reflection_chain
        rules << new_rule
        new_rule
      end

      def find(rule_class:, subject_path: nil, restrictable_class: nil)
        rules.detect do |rule|
          rule.class == rule_class \
          && rule.subject_path == subject_path \
          && rule.restrictable_class == restrictable_class
        end
      end
    end
  end
end
