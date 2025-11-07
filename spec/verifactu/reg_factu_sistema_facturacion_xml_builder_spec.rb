require 'spec_helper'


RSpec.describe Verifactu::RegFactuSistemaFacturacionXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegFactuSistemaFacturacion' do

      # Create la cabecera
      cabecera = cabecera_con_representante

      # Create a high invoice with the necessary data
      huella = huella_inicial
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Generate the XML of the high record
      registro_alta_xml = Verifactu::HighRecordXmlBuilder.build(registo_alta_factura)

      # Generate el XML
      xml = Verifactu::RegFactuSistemaFacturacionXmlBuilder.build(cabecera, registro_alta_xml)
      #p "xml: #{xml.root.to_xml}"

      # Validación del XML contra el esquema XSD
      validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml.root.to_xml)

      expect(validate_schema[:valid]).to be true

    end

  end
end
