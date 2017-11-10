describe Admin::Authorization, type: :service do
  describe 'class methods' do
    describe '.call' do
      let(:subject) { described_class.call(args) }
      context 'success' do
        let(:args) { { username: Rails.application.secrets.admin_user, password: 'password' } }
        it { expect(subject).to be_success }
      end
      context 'failed' do
        let(:args) { { username: Rails.application.secrets.admin_user, password: 'foo' } }
        it { expect(subject).not_to be_success }
      end
    end
  end
end
