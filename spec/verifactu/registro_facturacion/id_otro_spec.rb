require 'spec_helper'

RSpec.describe Verifactu::RegistroFacturacion::IDOtro do

  describe '#initialize' do

    it "is valid with a valid country code" do
      id_otro = Verifactu::RegistroFacturacion::IDOtro.new(
        codigo_pais: 'NP', id_type: '06', id: '123456789')

      expect(id_otro.codigo_pais).to eq('NP')
      expect(id_otro.id_type).to eq('06')
      expect(id_otro.id).to eq('123456789')
    end

  end

end
