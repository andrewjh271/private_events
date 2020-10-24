require 'rails_helper'

RSpec.describe "events/index", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    Event.create!(
      name: "Event 1",
      location: "Location",
      date: '2022/11/11',
      description: "MyText",
      host: user
    )
    Event.create!(
      name: "Event 2",
      location: "Location",
      date: '2022/12/12',
      description: "MyText",
      host: user
    )
    @events = Event.all
  end

  it "renders a list of events" do
    render
    assert_select "div", text: "Event 1", count: 1
    assert_select "div", text: "Event 2", count: 1
    assert_select "div", /Nov 11 2022 12:00am/, count: 1
    assert_select "div", /Dec 12 2022 12:00am/, count: 1
    assert_select "div", /Location/, count: 2
    assert_select 'a', /Info/, count: 2
  end
end
