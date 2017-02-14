require 'rails_helper'

describe AccountProcessor do
  describe 'initialize' do
    context 'when param is nil' do
      it 'initializes with nil value' do
        processor = AccountProcessor.new
        expect(processor.data).to be_nil
      end
    end

    context 'when param is present' do
      it 'initializes with passed value' do
        uuid = SecureRandom.uuid
        data = OpenStruct.new(
          uuid: uuid,
          bills: OpenStruct.new(
            '1234567890-abc' => 99.9
          )
        )
        processor = AccountProcessor.new(data)
        expect(processor.data.uuid).to eq uuid
      end
    end

    context 'when data value is given after initialize' do
      it 'set the value' do
        processor = AccountProcessor.new
        uuid = SecureRandom.uuid
        data = OpenStruct.new(
          uuid: uuid,
          bills: [
            '1234hasdf323',
            'weq130998'
          ]
        )
        processor.data = data
        expect(processor.data.uuid).to eq uuid
      end
    end
  end

  describe '#calculate_total_amount' do
    context 'when data is not available' do
      it "returns 0" do
        processor = AccountProcessor.new
        results = processor.calculate_total_amount
        expect(results).to eq 0
      end
    end
    context 'when data is available' do
      it "calculates the average of the bills" do
        uuid = SecureRandom.uuid
        processor = AccountProcessor.new({
          'uuid' => uuid,
          'bills' => [
            { 'amount' => 'MTUuMA==\n' },
            { 'amount' => 'MTUuMB=\n' }
          ]
        })
        expected = (Base64.decode64('MTUuMA==\n').to_f + Base64.decode64('MTUuMB=\n').to_f) / 2
        results = processor.calculate_total_amount
        expect(results).to eq expected
      end
    end
  end

  describe 'uuid' do
    it "returns the uuid from response" do
      uuid = SecureRandom.uuid
      processor = AccountProcessor.new({
        'uuid' => uuid,
        'bills' => [
          '10asdasd00',
          '100asdda',
          100
        ]
      })
      results = processor.uuid
      expect(results).to eq uuid
    end
  end
end
