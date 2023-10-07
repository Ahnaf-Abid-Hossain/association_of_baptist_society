require 'rails_helper'

RSpec.describe "meeting_notes/index", type: :view do
  before(:each) do
    assign(:meeting_notes, [
      MeetingNote.create!(
        title: "Title",
        content: "MyText",
        user: nil
      ),
      MeetingNote.create!(
        title: "Title",
        content: "MyText",
        user: nil
      )
    ])
  end

  it "renders a list of meeting_notes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
