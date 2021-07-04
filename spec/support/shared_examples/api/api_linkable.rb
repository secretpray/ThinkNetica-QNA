shared_examples_for 'API Linkable' do
  it 'returns list of links' do
    expect(links_response.size).to eq links.size
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |field|
      expect(link_response[field]).to eq link.send(field).as_json
    end
  end
end
