require 'spec_helper'


RSpec.describe Verifactu::RegistroAltaXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegistroAlta' do

      # Genera la huella para el registro de alta de una factura
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Genera el XML
      xml = Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)
      #p "xml: #{x.root.to_xml}"
      #
      validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml.root.to_xml)
      expect(validate_schema[:errors]).to be_empty
    end

    it 'creates a valid XML representation of RegistroAlta with system informatic using IDOtro' do
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      registo_alta_factura = registro_alta_factura_valido(huella) do |b|
        b.con_sistema_informatico(
          nombre_razon: 'Mi empresa SL', 
          id_otro: {
            codigo_pais: "DE",
            id: "123456789",
            id_type: "06"
          },
          nombre_sistema_informatico: 'Mi sistema', 
          id_sistema_informatico: 'MB',
          version: '1.0.0', 
          numero_instalacion: 'Instalacion 1',
          tipo_uso_posible_solo_verifactu: 'S', 
          tipo_uso_posible_multi_ot: 'S',
          indicador_multiples_ot: 'S'
        )
      end

      # Genera el XML
      xml = Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)
      # p "xml: #{xml}"

      validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml.root.to_xml)
      expect(validate_schema[:errors]).to be_nil
      expect(validate_schema[:valid]).to be true

      sum1_ns = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd'

      expect(xml.root.xpath('sum1:SistemaInformatico/sum1:NIF', 'sum1' => sum1_ns).first).to be_nil
      expect(xml.root.xpath('sum1:SistemaInformatico/sum1:IDOtro/sum1:CodigoPais', 'sum1' => sum1_ns).first.text).to eq('DE')
      expect(xml.root.xpath('sum1:SistemaInformatico/sum1:IDOtro/sum1:IDType', 'sum1' => sum1_ns).first.text).to eq('06')
      expect(xml.root.xpath('sum1:SistemaInformatico/sum1:IDOtro/sum1:ID', 'sum1' => sum1_ns).first.text).to eq('123456789')
    end
  end
end
