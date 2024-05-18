require 'rails_helper'

RSpec.describe "events/show", type: :view do
  # include Devise::Test::ControllerHelpers
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    @event = Event.create!(
      name: "Event 1",
      location: "Space Needle",
      date: '2032/11/11',
      description: "MyText",
      host: user
    )
    sign_in user
  end

  # spec/rails_helper.rb
  # config.include Devise::Test::ControllerHelpers, type: :view

  it "renders attributes" do
    render
    expect(rendered).to match(/Event 1/)
    expect(rendered).to match(/Space Needle/)
    expect(rendered).to match(/Nov 11 2032 12:00am/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/#{user.username}/)
  end
end
