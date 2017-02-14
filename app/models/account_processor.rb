class AccountProcessor
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end

  def calculate_total_amount
    return 0.0 if @data.nil? || @data['bills'].empty?
    acum = 0.0
    size = @data['bills'].size
    @data['bills'].each do |bill|
      val = Base64.decode64(bill['amount'])
      acum += val.to_f
    end
    return acum / size if acum > 0.0
    return 0.0 if acum <= size
  end

  def uuid
    @data['uuid']
  end
end
