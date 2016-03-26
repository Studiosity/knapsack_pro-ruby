module KnapsackPro
  module Adapters
    class RSpecAdapter < BaseAdapter
      TEST_DIR_PATTERN = 'spec/**{,/*/**}/*_spec.rb'

      def self.test_path(example_group)
        unless example_group[:turnip]
          until example_group[:parent_example_group].nil?
            example_group = example_group[:parent_example_group]
          end
        end

        example_group[:file_path]
      end

      def bind_time_tracker
        ::RSpec.configure do |config|
          config.before(:each) do
            current_example_group =
              if ::RSpec.respond_to?(:current_example)
                ::RSpec.current_example.metadata[:example_group]
              else
                example.metadata
              end
            KnapsackPro.tracker.current_test_path = KnapsackPro::Adapters::RSpecAdapter.test_path(current_example_group)
            KnapsackPro.tracker.start_timer
          end

          config.after(:each) do
            KnapsackPro.tracker.stop_timer
          end

          config.after(:suite) do
            KnapsackPro.logger.info(KnapsackPro::Presenter.global_time)
          end
        end
      end

      def bind_save_report
        ::RSpec.configure do |config|
          config.after(:suite) do
            KnapsackPro.tracker.example_count = config.reporter.examples.count
            KnapsackPro.tracker.failure_count = config.reporter.failed_examples.count
            KnapsackPro::Report.save
          end
        end
      end
    end

    # This is added to provide backwards compatibility
    # In case someone is doing switch from knapsack gem to the knapsack_pro gem
    # and didn't notice the class name changed
    class RspecAdapter < RSpecAdapter
    end
  end
end
