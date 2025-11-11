require 'spec_helper'

RSpec.describe Verifactu::InvoiceRegistration::LegalEntity do
  describe '.create_from_nif' do

    it 'creates an instance with valid NIF' do
      persona = Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(business_name: 'Test Name', nif: '12345678Z')
      expect(persona).to be_a(Verifactu::InvoiceRegistration::LegalEntity)
      expect(persona.business_name).to eq('Test Name')
      expect(persona.nif).to eq('12345678Z')
    end

  end
  describe '.create_from_id_otro' do

    it 'creates an instance with valid OtherId' do
      id_otro = Verifactu::InvoiceRegistration::OtherId.new(codigo_pais: 'FR', id_type: '02', id: '123456789')
      persona = Verifactu::InvoiceRegistration::LegalEntity.create_from_id_otro(business_name: 'Test Name', other_id: id_otro)
      expect(persona).to be_a(Verifactu::InvoiceRegistration::LegalEntity)
      expect(persona.business_name).to eq('Test Name')
      expect(persona.other_id).to eq(id_otro)
    end

  end
end
