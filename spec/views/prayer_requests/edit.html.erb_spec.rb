require 'rails_helper'

RSpec.describe('prayer_requests/edit') do
  before do
    @user1 = FactoryBot.create(:user, email: 'user1@gmail.com')
    @admin = FactoryBot.create(:admin_user, email: 'admin@gmail.com')
  end

  after do
    @user1.destroy!
    @admin.destroy!
  end

  context 'admin editing their own anonymous prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @admin
      prayer_request = FactoryBot.create(:prayer_request, user: @admin, is_anonymous: true)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]'

        assert_select 'input[type=?][checked=?][name=?]', 'checkbox', 'checked', 'prayer_request[is_anonymous]'
      end
    end
  end

  context 'admin editing their own non-anonymous prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @admin
      prayer_request = FactoryBot.create(:prayer_request, user: @admin, is_anonymous: false)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]'

        assert_select 'input[type=?][checked=?][name=?]', 'checkbox', 'checked', 'prayer_request[is_anonymous]', count: 0
        assert_select 'input[type=?][name=?]', 'checkbox', 'prayer_request[is_anonymous]'
      end
    end
  end

  context 'admin editing anonymous user prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @admin
      prayer_request = FactoryBot.create(:prayer_request, user: @user1, is_anonymous: true)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]'

        assert_select 'input[type=?][name=?]', 'checkbox', 'prayer_request[is_anonymous]', count: 0
      end
    end
  end

  context 'admin editing non-anonymous user prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @admin
      prayer_request = FactoryBot.create(:prayer_request, user: @user1, is_anonymous: false)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]'

        assert_select 'input[type=?][name=?]', 'checkbox', 'prayer_request[is_anonymous]', count: 0
      end
    end
  end

  context 'user editing their own anonymous prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @user1
      prayer_request = FactoryBot.create(:prayer_request, user: @user1, is_anonymous: true)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]', count: 0

        assert_select 'input[type=?][name=?]', 'checkbox', 'prayer_request[is_anonymous]'
      end
    end
  end

  context 'user editing their own non-anonymous prayer request' do
    it 'renders the edit prayer_request form' do
      sign_in @user1
      prayer_request = FactoryBot.create(:prayer_request, user: @user1, is_anonymous: false)
      assign(:prayer_request, prayer_request)

      render

      assert_select 'form[action=?][method=?]', prayer_request_path(prayer_request), 'post' do
        assert_select 'input[name=?]', 'prayer_request[request]'

        assert_select 'input[name=?]', 'prayer_request[status]', count: 0

        assert_select 'input[type=?][checked=?][name=?]', 'checkbox', 'checked', 'prayer_request[is_anonymous]', count: 0
        assert_select 'input[type=?][name=?]', 'checkbox', 'prayer_request[is_anonymous]'
      end
    end
  end
end
