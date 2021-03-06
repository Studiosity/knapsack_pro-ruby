describe KnapsackPro::Config::Env do
  before { stub_const("ENV", {}) }

  describe '.ci_node_total' do
    subject { described_class.ci_node_total }

    context 'when ENV exists' do
      context 'when KNAPSACK_PRO_CI_NODE_TOTAL has value' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_CI_NODE_TOTAL' => '5' }) }
        it { should eq 5 }
      end

      context 'when CI environment has value' do
        before do
          expect(described_class).to receive(:ci_env_for).with(:node_total).and_return(4)
        end

        it { should eq 4 }
      end
    end

    context "when ENV doesn't exist" do
      it { should eq 1 }
    end
  end

  describe '.ci_node_index' do
    subject { described_class.ci_node_index }

    context 'when ENV exists' do
      context 'when KNAPSACK_PRO_CI_NODE_INDEX has value' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_CI_NODE_INDEX' => '3' }) }
        it { should eq 3 }
      end

      context 'when CI environment has value' do
        before do
          expect(described_class).to receive(:ci_env_for).with(:node_index).and_return(2)
        end

        it { should eq 2 }
      end
    end

    context "when ENV doesn't exist" do
      it { should eq 0 }
    end
  end

  describe '.commit_hash' do
    subject { described_class.commit_hash }

    context 'when ENV exists' do
      context 'when KNAPSACK_PRO_COMMIT_HASH has value' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_COMMIT_HASH' => '3fa64859337f6e56409d49f865d13fd7' }) }
        it { should eq '3fa64859337f6e56409d49f865d13fd7' }
      end

      context 'when CI environment has value' do
        before do
          expect(described_class).to receive(:ci_env_for).with(:commit_hash).and_return('fe61a08118d0d52e97c38666eba1eaf3')
        end

        it { should eq 'fe61a08118d0d52e97c38666eba1eaf3' }
      end
    end

    context "when ENV doesn't exist" do
      it { should be nil }
    end
  end

  describe '.branch' do
    subject { described_class.branch }

    context 'when ENV exists' do
      context 'when KNAPSACK_PRO_BRANCH has value' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_BRANCH' => 'master' }) }
        it { should eq 'master' }
      end

      context 'when CI environment has value' do
        before do
          expect(described_class).to receive(:ci_env_for).with(:branch).and_return('feature-branch')
        end

        it { should eq 'feature-branch' }
      end
    end

    context "when ENV doesn't exist" do
      it { should be nil }
    end
  end

  describe '.project_dir' do
    subject { described_class.project_dir }

    context 'when ENV exists' do
      context 'when KNAPSACK_PRO_PROJECT_DIR has value' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_PROJECT_DIR' => '/home/user/myapp' }) }
        it { should eq '/home/user/myapp' }
      end

      context 'when CI environment has value' do
        before do
          expect(described_class).to receive(:ci_env_for).with(:project_dir).and_return('/home/runner/myapp')
        end

        it { should eq '/home/runner/myapp' }
      end
    end

    context "when ENV doesn't exist" do
      it { should be nil }
    end
  end

  describe '.test_file_pattern' do
    subject { described_class.test_file_pattern }

    context 'when ENV exists' do
      let(:test_file_pattern) { 'custom_spec/**{,/*/**}/*_spec.rb' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_TEST_FILE_PATTERN' => test_file_pattern }) }
      it { should eq test_file_pattern }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.repository_adapter' do
    subject { described_class.repository_adapter }

    context 'when ENV exists' do
      let(:repository_adapter) { 'git' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_REPOSITORY_ADAPTER' => repository_adapter }) }
      it { should eq repository_adapter }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.recording_enabled' do
    subject { described_class.recording_enabled }

    context 'when ENV exists' do
      let(:recording_enabled) { 'true' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_RECORDING_ENABLED' => recording_enabled }) }
      it { should eq recording_enabled }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.recording_enabled?' do
    subject { described_class.recording_enabled? }

    before do
      expect(described_class).to receive(:recording_enabled).and_return(recording_enabled)
    end

    context 'when enabled' do
      let(:recording_enabled) { 'true' }

      it { should be true }
    end

    context 'when disabled' do
      let(:recording_enabled) { nil }

      it { should be false }
    end
  end

  describe '.endpoint' do
    subject { described_class.endpoint }

    context 'when ENV exists' do
      let(:endpoint) { 'http://api-custom-url.knapsackpro.com' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_ENDPOINT' => endpoint }) }
      it { should eq endpoint }
    end

    context "when ENV doesn't exist" do
      context 'when default mode' do
        it { should eq 'http://api.knapsackpro.com' }
      end

      context 'when development mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'development' }) }
        it { should eq 'http://api.knapsackpro.dev:3000' }
      end

      context 'when test mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'test' }) }
        it { should eq 'http://api-staging.knapsackpro.com' }
      end

      context 'when production mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'production' }) }
        it { should eq 'http://api.knapsackpro.com' }
      end

      context 'when unknown mode' do
        before do
          expect(described_class).to receive(:mode).and_return(:fake)
        end

        it do
          expect { subject }.to raise_error('Missing environment variable KNAPSACK_PRO_ENDPOINT')
        end
      end
    end
  end

  describe '.test_suite_token' do
    subject { described_class.test_suite_token }

    context 'when ENV exists' do
      let(:token) { 'xyz' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_TEST_SUITE_TOKEN' => 'xyz' }) }
      it { should eq token }
    end

    context "when ENV doesn't exist" do
      it do
        expect { subject }.to raise_error('Missing environment variable KNAPSACK_PRO_TEST_SUITE_TOKEN')
      end
    end
  end

  describe '.test_suite_token_rspec' do
    subject { described_class.test_suite_token_rspec }

    context 'when ENV exists' do
      let(:test_suite_token_rspec) { 'rspec-token' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC' => test_suite_token_rspec }) }
      it { should eq test_suite_token_rspec }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.test_suite_token_minitest' do
    subject { described_class.test_suite_token_minitest }

    context 'when ENV exists' do
      let(:test_suite_token_minitest) { 'minitest-token' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_TEST_SUITE_TOKEN_MINITEST' => test_suite_token_minitest }) }
      it { should eq test_suite_token_minitest }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.test_suite_token_cucumber' do
    subject { described_class.test_suite_token_cucumber }

    context 'when ENV exists' do
      let(:test_suite_token_cucumber) { 'cucumber-token' }
      before { stub_const("ENV", { 'KNAPSACK_PRO_TEST_SUITE_TOKEN_CUCUMBER' => test_suite_token_cucumber }) }
      it { should eq test_suite_token_cucumber }
    end

    context "when ENV doesn't exist" do
      it { should be_nil }
    end
  end

  describe '.mode' do
    subject { described_class.mode }

    context 'when ENV exists' do
      context 'when development mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'development' }) }

        it { should eq :development }
      end

      context 'when test mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'test' }) }

        it { should eq :test }
      end

      context 'when production mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'production' }) }

        it { should eq :production }
      end

      context 'when fake mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => 'fake' }) }

        it do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context 'when blank mode' do
        before { stub_const("ENV", { 'KNAPSACK_PRO_MODE' => '' }) }

        it do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    context "when ENV doesn't exist" do
      it { should eq :production }
    end
  end

  describe '.ci_env_for' do
    let(:env_name) { :node_total }

    subject { described_class.ci_env_for(env_name) }

    context 'when CI has no value for env_name method' do
      before do
        expect(KnapsackPro::Config::CI::Circle).to receive_message_chain(:new, env_name).and_return(nil)
        expect(KnapsackPro::Config::CI::Semaphore).to receive_message_chain(:new, env_name).and_return(nil)
        expect(KnapsackPro::Config::CI::Buildkite).to receive_message_chain(:new, env_name).and_return(nil)
      end

      it do
        expect(subject).to be_nil
      end
    end

    context 'when CI has value for env_name method' do
      let(:circle_env) { double(:circle) }
      let(:semaphore_env) { double(:semaphore) }
      let(:buildkite_env) { double(:buildkite) }

      before do
        allow(KnapsackPro::Config::CI::Circle).to receive_message_chain(:new, env_name).and_return(circle_env)
        allow(KnapsackPro::Config::CI::Semaphore).to receive_message_chain(:new, env_name).and_return(semaphore_env)
        allow(KnapsackPro::Config::CI::Buildkite).to receive_message_chain(:new, env_name).and_return(buildkite_env)
      end

      it { should eq circle_env }

      context do
        let(:circle_env) { nil }

        it { should eq semaphore_env }
      end

      context do
        let(:circle_env) { nil }
        let(:semaphore_env) { nil }

        it { should eq buildkite_env }
      end
    end
  end
end
