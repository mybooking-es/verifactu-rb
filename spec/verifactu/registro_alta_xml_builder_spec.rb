require 'spec_helper'


RSpec.describe Verifactu::RegistroAltaXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegistroAlta' do

      # Genera la huella para el registro de alta de una factura
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Genera el XML
      x = Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)
      #p "xml: #{x.root.to_xml}"

    end

    it 'creates a valid XML representation of RegistroAlta with Destinatario using IDOtro' do
      huella = huella_inicial
      registo_alta_factura = registro_alta_factura_valido(huella) do |b|
        b.agregar_destinatario_id_otro(
          nombre_razon: 'Mi empresa SL',
          codigo_pais: 'DE',
          id: '123456789',
          id_type: "06"
        )
      end

      # Genera el XML
      xml = Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)
      validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml.root.to_xml)


      expect(validate_schema[:errors]).to be_nil
      expect(validate_schema[:valid]).to be true

      sum1_ns = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd'
      id_destinatario_element = xml.root.xpath('sum1:Destinatarios/sum1:IDDestinatario[2]', 'sum1' => sum1_ns).first
      expect(id_destinatario_element.xpath('sum1:NIF', 'sum1' => sum1_ns).first).to be_nil
      expect(id_destinatario_element.xpath('sum1:IDOtro/sum1:CodigoPais', 'sum1' => sum1_ns).first.text).to eq('DE')
      expect(id_destinatario_element.xpath('sum1:IDOtro/sum1:IDType', 'sum1' => sum1_ns).first.text).to eq('06')
      expect(id_destinatario_element.xpath('sum1:IDOtro/sum1:ID', 'sum1' => sum1_ns).first.text).to eq('123456789')
    end
  end
end
