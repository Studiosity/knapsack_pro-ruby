module KnapsackPro
  class Tracker
    include Singleton

    attr_reader :global_time, :test_files_with_time
    attr_writer :current_test_path
    attr_accessor :example_count, :failure_count, :pending_count

    def initialize
      set_defaults
    end

    def reset!
      set_defaults
    end

    def start_timer
      @start_time = now_without_mock_time.to_f
    end

    def stop_timer
      @execution_time = now_without_mock_time.to_f - @start_time
      update_global_time
      update_test_file_time
      @execution_time
    end

    def save_example_counts(reporter)
      # If the current test path hasn't been assigned then something has gone terribly wrong.
      # Just ignore saving the example count..
      return unless @current_test_path.present?

      @test_files_with_time[current_test_path].merge!(current_example_counts reporter) { |_, val1, val2| val1 + val2 }
      update_global_example_counts reporter
    end

    def current_test_path
      raise("current_test_path needs to be set by Knapsack Pro Adapter's bind method") unless @current_test_path
      @current_test_path.sub(/^\.\//, '')
    end

    def to_a
      test_files = []
      @test_files_with_time.each do |path, attributes|
        test_files << attributes.slice(:example_count, :failure_count, :pending_count).merge(
          path: path,
          time_execution: attributes[:runtime]
        )
      end
      test_files
    end

    private

    def set_defaults
      @global_time = 0
      @test_files_with_time = {}
      @test_path = nil
      @example_count = 0
      @failure_count = 0
      @pending_count = 0
    end

    def update_global_time
      @global_time += @execution_time
    end

    def update_test_file_time
      @test_files_with_time[current_test_path] ||= { runtime: 0 }
      @test_files_with_time[current_test_path][:runtime] += @execution_time
    end

    def current_example_counts(reporter)
      {
        example_count: reporter.examples.count - @example_count,
        failure_count: reporter.failed_examples.count - @failure_count,
        pending_count: reporter.pending_examples.count - @pending_count
      }
    end

    def update_global_example_counts(reporter)
      @example_count = reporter.examples.count
      @failure_count = reporter.failed_examples.count
      @pending_count = reporter.pending_examples.count
    end

    def now_without_mock_time
      Time.now_without_mock_time
    end
  end
end
