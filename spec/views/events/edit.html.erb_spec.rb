require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      name: "MyString",
      location: "MyString",
      description: "MyText",
      host: nil
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "input[name=?]", "event[location]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "input[name=?]", "event[host_id]"
    end
  end
end
