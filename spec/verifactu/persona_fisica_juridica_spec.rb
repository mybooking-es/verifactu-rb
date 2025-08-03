require 'spec_helper'

RSpec.describe Verifactu::RegistroFacturacion::PersonaFisicaJuridica do
  describe '.create_from_nif' do

    it 'creates an instance with valid NIF' do
      persona = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(nombre_razon: 'Test Name', nif: '12345678Z')
      expect(persona).to be_a(Verifactu::RegistroFacturacion::PersonaFisicaJuridica)
      expect(persona.nombre_razon).to eq('Test Name')
      expect(persona.nif).to eq('12345678Z')
    end

  end
  describe '.create_from_id_otro' do

    it 'creates an instance with valid IDOtro' do
      id_otro = Verifactu::RegistroFacturacion::IDOtro.new(codigo_pais: 'FR', id_type: '02', id: '123456789')
      persona = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_id_otro(nombre_razon: 'Test Name', id_otro: id_otro)
      expect(persona).to be_a(Verifactu::RegistroFacturacion::PersonaFisicaJuridica)
      expect(persona.nombre_razon).to eq('Test Name')
      expect(persona.id_otro).to eq(id_otro)
    end

  end
end
