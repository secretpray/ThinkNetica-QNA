shared_examples_for 'API Attacheble' do
  it 'returns list of links' do
    expect(files_response.size).to eq files.size
  end

  it 'return url' do
    expect(file_response).to eq rails_blob_url(file, only_path: true )
  end
end
