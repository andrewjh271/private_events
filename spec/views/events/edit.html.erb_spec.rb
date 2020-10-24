require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    sign_in user
    @event = Event.create!(
      name: "Event 1",
      location: "Location",
      date: '2022/11/11',
      description: "MyText",
      host: user
    )
  end

  # spec/rails_helper.rb
  # config.include Devise::Test::ControllerHelpers, type: :view

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do
    assert_select "input[name=?]", "event[name]"
    assert_select "input[name=?]", "event[location]"
    assert_select "textarea[name=?]", "event[description]"
    end
  end
end
