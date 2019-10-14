module KnapsackPro
  module Client
    module API
      module V1
        class BuildSubsets < Base
          class << self
            def create(args)
              action_class.new(
                endpoint_path: '/v1/build_subsets',
                http_method: :post,
                request_hash: {
                  :commit_hash => args.fetch(:commit_hash),
                  :branch => args.fetch(:branch),
                  :node_total => args.fetch(:node_total),
                  :node_index => args.fetch(:node_index),
                  :test_files => args.fetch(:test_files),
                  :example_count => args.fetch(:example_count),
                  :failure_count => args.fetch(:failure_count),
                  :pending_count => args.fetch(:pending_count),
                  :build_url => args.fetch(:build_url)
                }
              )
            end
          end
        end
      end
    end
  end
end
