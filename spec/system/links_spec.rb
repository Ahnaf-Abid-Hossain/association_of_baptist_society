require 'rails_helper'

RSpec.describe('Links') do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let (:links) { [
    { label: 'Link 1', url: 'https://www.google1.com', order: 1, user: admin_user },
    { label: 'Link 2', url: 'https://www.google2.com', order: 2, user: admin_user },
    { label: 'Link 3', url: 'https://www.google3.com', order: 3, user: admin_user }
  ] }
  let(:link_data) { { label: 'Test', url: 'https://test.com', order: 800_000 } }

  before do
    driven_by(:rack_test)
  end

  context 'as admin' do
    # Sign in as an admin
    before do
      sign_in admin_user
    end

    context 'viewing links' do
      before(:each) do
        Link.destroy_all
      end
  
      it 'displays built-in links (for non admins)' do
        # Expect 0 links
        expect(Link.count).to(eq(0))
        
        # Visit home page
        visit '/'
  
        # Test for links in order
        expect(page.find('.quick-links .navbar-link:nth-child(1)')['href']).to(eq(root_path))
        expect(page.find('.quick-links .navbar-link:nth-child(2)')['href']).to(eq(meeting_notes_path))
        expect(page.find('.quick-links .navbar-link:nth-child(3)')['href']).to(eq(prayer_requests_path))
        expect(page.find('.quick-links .navbar-link:nth-child(4)')['href']).to(eq(approvals_index_path))
        expect(page.find('.quick-links .navbar-link:nth-child(5)')['href']).to(eq(links_path))
  
        # Test for no extra links
        expect(page).not_to have_css('.quick-links .navbar-link:nth-child(6)')
      end
  
      it 'displays links in order (as an admin)' do
        # Expect 0 links
        expect(Link.count).to(eq(0))
  
        # Create three links {1, 2, 3}
        expect do
          Link.create!(links)
        end.to(change(Link, :count).by(3))
        
        # Visit home page
        visit '/'
  
        # Test for links in order
        expect(page.find('.quick-links .navbar-link:nth-child(6)')['href']).to(eq(links[0][:url]))
        expect(page.find('.quick-links .navbar-link:nth-child(7)')['href']).to(eq(links[1][:url]))
        expect(page.find('.quick-links .navbar-link:nth-child(8)')['href']).to(eq(links[2][:url]))
      end

      it 'shows the author of a link' do
        # Create link
        FactoryBot.create(:link, user: admin_user, order: 1)

        # Visit links path
        visit links_path

        # Expect to see our name as a link
        author_name = "#{admin_user.user_first_name} #{admin_user.user_last_name}"
        expect(page).to(have_link(author_name, href: user_path(admin_user)))
      end
    end

    context 'creating links' do
      it 'allows admins to visit #new' do
        # GET new link page
        get '/links/new'

        # Expect to be allowed into the new page
        expect(response).to(have_http_status(:ok))
      end

      it 'allows admins to create links' do
        # Check for overall creation of 1 link
        expect do
          # Post to the links page
          post '/links', params: { link: link_data }

          # Expect to succeed
          expect(response).to(have_http_status(:found))

          # Expect to be author of latest link
          expect(Link.last.user).to(eq(admin_user))
        end.to(change(Link, :count).by(1))
      end

      it 'prevents admins from creating links with invalid data' do
        # POST to links page
        post '/links', params: { link: link_data.merge(url: nil) }

        # Expect to get :unprocessable_entity
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end

    context 'deleting links' do
      it 'allows admins to delete links' do
        # Declare link in this block so we can access it later
        link = nil

        # Expect to increase number of links by 1
        expect do
          # Create a link to delete
          link = FactoryBot.create(:link, user: admin_user, order: 1)
        end.to(change(Link, :count).by(1))

        # Expect to reduce number of links by 1
        expect do
          # DELETE to link page
          delete link_path(link)

          # Expect to succeed
          expect(response).to(have_http_status(:found))
        end.to(change(Link, :count).by(-1))
      end

      it 'reorders deleted links' do
        # Delete all links
        Link.destroy_all

        # Create three links {1, 2, 3}
        link1, link2, link3 = Link.create!(links)

        # Expect 3 links
        expect(Link.count).to(eq(3))
  
        # DELETE to link2
        delete(link_path(link2))
  
        # Expect to be accepted
        expect(response).to(have_http_status(:found))
        
        # Expect link1 to still be (order: 1)
        link1_new = Link.find(link1.id)
        expect(link1_new.order).to(eq(1))
        
        # Expect link3 to be (order: 2) now
        link3_new = Link.find(link3.id)
        expect(link3_new.order).to(eq(2))
      end
    end
  end

  context 'as non-admin' do
    # Sign in as a non-admin
    before do
      sign_in user
    end

    context 'viewing links' do
      before(:each) do
        Link.destroy_all
      end

      it 'displays new links' do
        # Create a link
        link = FactoryBot.create(:link, user: admin_user, order: 1)
  
        # Visit home page
        visit '/'
  
        # Test for link
        expect(page).to(have_link(link.label, href: link.url))
      end
  
      it 'displays links bar with CSS' do
        # Visit home page
        visit '/'
  
        # Test for .quick-links element
        expect(page).to(have_css('div.quick-links'))
      end
  
      it 'displays built-in links (for non admins)' do
        # Expect 0 links
        expect(Link.count).to(eq(0))
        
        # Visit home page
        visit '/'
  
        # Test for links in order
        expect(page.find('.quick-links .navbar-link:nth-child(1)')['href']).to(eq(root_path))
        expect(page.find('.quick-links .navbar-link:nth-child(2)')['href']).to(eq(meeting_notes_path))
        expect(page.find('.quick-links .navbar-link:nth-child(3)')['href']).to(eq(prayer_requests_path))
  
        # Test for no extra links
        expect(page).not_to have_css('.quick-links .navbar-link:nth-child(4)')
      end
  
      it 'displays links in order (as a non-admin)' do
        # Expect 0 links
        expect(Link.count).to(eq(0))
  
        # Create three links {1, 2, 3}
        expect do
          Link.create!(links)
        end.to(change(Link, :count).by(3))
        
        # Visit home page
        visit '/'
  
        # Test for links in order
        expect(page.find('.quick-links .navbar-link:nth-child(4)')['href']).to(eq(links[0][:url]))
        expect(page.find('.quick-links .navbar-link:nth-child(5)')['href']).to(eq(links[1][:url]))
        expect(page.find('.quick-links .navbar-link:nth-child(6)')['href']).to(eq(links[2][:url]))
      end
    end

    context 'creating links' do
      it 'prevents non-admins from visiting #new' do
        # GET new link page
        get '/links/new'

        # Expect to be directed away
        expect(response).to(redirect_to('/'))
      end

      it 'prevents non-admins from creating links' do
        # POST to links page
        post '/links', params: { link: link_data }

        # Expect to be forbidden
        expect(response).to(have_http_status(:forbidden))
      end
    end

    context 'deleting links' do
      it 'prevents non-admins from deleting links' do
        # Create a link to delete
        link = FactoryBot.create(:link, user: admin_user, order: 1)

        # DELETE to link page
        delete link_path(link)

        # Expect to be forbidden
        expect(response).to(have_http_status(:forbidden))
      end
    end
  end
end