require 'rails_helper'

RSpec.describe('users/new') do
  before do
    assign(:user, FactoryBot.create(:user))
  end

  # it "renders new user form" do
  #   render

  #   assert_select "form[action=?][method=?]", users_path, "post" do
  #   end
  # end

  pending 'renders new user form'
end
