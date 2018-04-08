RSpec.describe Wordpress do
  it "has a version number" do
    expect(Wordpress::VERSION).not_to be nil
  end
end
