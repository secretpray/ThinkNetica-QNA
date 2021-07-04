shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'return 401 status if there is no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'return 401 status if access token invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
