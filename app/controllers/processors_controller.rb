class ProcessorsController < ApplicationController
  USER = 'gastrupul'
  EMAIL = 'gtrujillo@tecnocomfenalco.edu.co'

  def get_accounts
    @processor = AccountProcessor.new
    url = "https://deudas.herokuapp.com/accounts"
    @processor.data = JSON.parse(RestClient.post(url, { name: USER, email: EMAIL } ))
    redirect_to send_results_path(
      average: @processor.calculate_total_amount,
      uuid: @processor.uuid
    )
  end

  def send_results
    if params[:average].present? && params[:uuid].present?
      average = params[:average]
      uuid = params[:uuid]
      url = "https://deudas.herokuapp.com/accounts/#{uuid}"
      rest_resource = RestClient::Request.new(
        method: :put,
        url: url,
        payload: { average: average }.to_json,
        headers: { accept: :json, content_type: :json }
      )

      render json: JSON.parse(rest_resource.execute), status: 200
    else
      render json: 'No data available', status: 500
    end
  end
end
