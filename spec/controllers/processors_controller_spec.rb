require 'rails_helper'

describe ProcessorsController do

  describe 'GET get_accounts' do
    before do
      name = 'gastrupul'
      email = 'gaston.trujillo.java@gmail.com'
      @body = { name: name, email: email }.to_json
      @uri = "https://deudas.herokuapp.com/accounts"
      @rest_resource = RestClient.post(@uri, @body)
      @processor = AccountProcessor.new
    end

    context 'with correct params' do
      before do
        stub_request(:post, @uri)
          .with(
            body: @body
          )
          .to_return(
            status: 200,
            body: '{"uuid": "1403041e-032c-41dc-ad4f-9110f3c9aad5", "bills": ["10", "10"]}'
          )
      end

      it 'instantiates a new AccountProcessor' do
        expect(AccountProcessor).to receive(:new).and_return(@processor)

        get :get_accounts
      end

      it 'makes an external API call' do
        allow(AccountProcessor).to receive(:new).and_return(@processor)
        expect(RestClient).to receive(:post).with(@uri, @body).and_return(@rest_resource)

        get :get_accounts
      end

      it 'processes returned data' do
        allow(AccountProcessor).to receive(:new).and_return(@processor)
        allow(RestClient::Resource).to receive(:new).with(@uri, @body).and_return(@rest_resource)

        get :get_accounts

        results = @processor.calculate_total_amount
        expect(results).to eq 10.0
      end

      it 'redirects to send_results action' do
        allow(AccountProcessor).to receive(:new).and_return(@processor)
        allow(RestClient::Resource).to receive(:new).with(@uri, @body).and_return(@rest_resource)

        expect(get :get_accounts).to redirect_to(send_results_path(assigns([:average, :uuid])))
      end
    end
  end

  describe 'PUT send_results' do
    context 'when params are correct' do
      before do
        @average = '10.0'
        @uuid = '1403041e-032c-41dc-ad4f-9110f3c9aad5'
        @uri = "https://deudas.herokuapp.com/accounts/#{@uuid}"
        @rest_resource = RestClient::Resource.new(@uri)
        stub_request(:put, @uri)
          .to_return(
            status: 200,
            body: '{"average": "10.0"}'
          )
      end
      it 'updates values for given UUID' do
        allow(controller).to receive(:params).and_return({average: @average, uuid: @uuid})
        allow(RestClient::Resource).to receive(:new).with(@uri).and_return(@rest_resource)

        put :send_results

        expect(JSON.parse(response.body)['average']).to eq '10.0'
        expect(response.status).to eq 200
      end
    end
  end
end
