describe KnapsackPro::Config::CI::Semaphore do
  let(:env) { {} }

  before do
    stub_const('ENV', env)
  end

  it { should be_kind_of KnapsackPro::Config::CI::Base }

  describe '#node_total' do
    subject { described_class.new.node_total }

    context 'when environment exists' do
      let(:env) { { 'SEMAPHORE_THREAD_COUNT' => 4 } }
      it { should eql 4 }
    end

    context "when environment doesn't exist" do
      it { should be nil }
    end
  end

  describe '#node_index' do
    subject { described_class.new.node_index }

    context 'when environment exists' do
      let(:env) { { 'SEMAPHORE_CURRENT_THREAD' => 4 } }
      it { should eql 3 }
    end

    context "when environment doesn't exist" do
      it { should be nil }
    end
  end

  describe '#commit_hash' do
    subject { described_class.new.commit_hash }

    context 'when environment exists' do
      let(:env) { { 'REVISION' => '3fa64859337f6e56409d49f865d13fd7' } }
      it { should eql '3fa64859337f6e56409d49f865d13fd7' }
    end

    context "when environment doesn't exist" do
      it { should be nil }
    end
  end

  describe '#branch' do
    subject { described_class.new.branch }

    context 'when environment exists' do
      let(:env) { { 'BRANCH_NAME' => 'master' } }
      it { should eql 'master' }
    end

    context "when environment doesn't exist" do
      it { should be nil }
    end
  end

  describe '#project_dir' do
    subject { described_class.new.project_dir }

    context 'when environment exists' do
      let(:env) { { 'SEMAPHORE_PROJECT_DIR' => '/home/runner/knapsack_pro-ruby' } }
      it { should eql '/home/runner/knapsack_pro-ruby' }
    end

    context "when environment doesn't exist" do
      it { should be nil }
    end
  end
end
