
require "cancan/matchers"

describe "User abilities" do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context "when is a guest" do
    let(:user) { nil }
  end
end
