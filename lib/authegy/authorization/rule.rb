# frozen_string_literal: true

module Authegy
  module Authorization
    class Rule
      attr_reader :subject_path, :subjects, :restrictable_class,
                  :reflection_chain

      def initialize(subjects: [], subject_path: nil, restrictable_class: nil, reflection_chain: [])
        @subjects = subjects.map(&:to_sym)
        @subject_path = subject_path
        @reflection_chain = reflection_chain
        @restrictable_class = restrictable_class
      end

      def add_subject(subject)
        symbol = subject.to_sym
        @subjects << symbol unless symbol.in? @subjects
      end

      def self.association_joins_from_reflections(reflections)
        return unless reflections.any?

        reflections.reverse.reduce(nil) do |chain, reflection|
          association_name = reflection.name
          next association_name if chain.nil?

          { association_name => chain }
        end
      end
      delegate :association_joins_from_reflections, to: :class
    end
  end
end
