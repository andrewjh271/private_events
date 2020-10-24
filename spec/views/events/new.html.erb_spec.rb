require 'rails_helper'

RSpec.describe "events/new", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    sign_in user
    @event = Event.new
  end

  # spec/rails_helper.rb
  # config.include Devise::Test::ControllerHelpers, type: :view

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do
    assert_select "input[name=?]", "event[name]"
    assert_select "input[name=?]", "event[location]"
    assert_select "textarea[name=?]", "event[description]"
    end
  end
end
