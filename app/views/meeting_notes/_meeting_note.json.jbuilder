json.extract!(meeting_note, :id, :title, :content, :date, :id, :created_at, :updated_at)
json.url(meeting_note_url(meeting_note, format: :json))
