shared_examples_for 'API Commentable' do
  it 'returns list of answers' do
    expect(comments_response.size).to eq comments.size
  end

  it 'returns all public fields' do
    %w[id body user_id created_at updated_at].each do |field|
      expect(comment_response[field]).to eq comment.send(field).as_json
    end
  end

  it 'does not return private fields' do
    %w[commentable_id, commentable_type].each do |field|
      expect(comment_response).to_not have_key(field)
    end
  end
end
