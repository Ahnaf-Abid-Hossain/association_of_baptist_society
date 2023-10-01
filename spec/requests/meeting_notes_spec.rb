require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe('/meeting_notes') do
  # This should return the minimal set of attributes required to create a valid
  # MeetingNote. As you add validations to MeetingNote, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      MeetingNote.create!(valid_attributes)
      get meeting_notes_url
      expect(response).to(be_successful)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      meeting_note = MeetingNote.create!(valid_attributes)
      get meeting_note_url(meeting_note)
      expect(response).to(be_successful)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      sign_in FactoryBot.create(:user)
      get new_meeting_note_url
      expect(response).to(be_successful)
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      meeting_note = MeetingNote.create!(valid_attributes)
      get edit_meeting_note_url(meeting_note)
      expect(response).to(be_successful)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new MeetingNote' do
        expect do
          post(meeting_notes_url, params: { meeting_note: valid_attributes })
        end.to(change(MeetingNote, :count).by(1))
      end

      it 'redirects to the created meeting_note' do
        post meeting_notes_url, params: { meeting_note: valid_attributes }
        expect(response).to(redirect_to(meeting_note_url(MeetingNote.last)))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new MeetingNote' do
        expect do
          post(meeting_notes_url, params: { meeting_note: invalid_attributes })
        end.not_to(change(MeetingNote, :count))
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post meeting_notes_url, params: { meeting_note: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested meeting_note' do
        meeting_note = MeetingNote.create!(valid_attributes)
        patch meeting_note_url(meeting_note), params: { meeting_note: new_attributes }
        meeting_note.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the meeting_note' do
        meeting_note = MeetingNote.create!(valid_attributes)
        patch meeting_note_url(meeting_note), params: { meeting_note: new_attributes }
        meeting_note.reload
        expect(response).to(redirect_to(meeting_note_url(meeting_note)))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        meeting_note = MeetingNote.create!(valid_attributes)
        patch meeting_note_url(meeting_note), params: { meeting_note: invalid_attributes }
        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested meeting_note' do
      meeting_note = MeetingNote.create!(valid_attributes)
      expect do
        delete(meeting_note_url(meeting_note))
      end.to(change(MeetingNote, :count).by(-1))
    end

    it 'redirects to the meeting_notes list' do
      meeting_note = MeetingNote.create!(valid_attributes)
      delete meeting_note_url(meeting_note)
      expect(response).to(redirect_to(meeting_notes_url))
    end
  end
end
