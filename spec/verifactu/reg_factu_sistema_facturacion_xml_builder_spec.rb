require 'spec_helper'


RSpec.describe Verifactu::RegFactuSistemaFacturacionXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegFactuSistemaFacturacion' do

      # Crea la cabecera
      cabecera = cabecera_con_representante

      # Crea una factura de alta con los datos necesarios
      huella = huella_inicial
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Genera el XML del registro de alta
      registro_alta_xml = Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)

      # Genera el XML
      xml = Verifactu::RegFactuSistemaFacturacionXmlBuilder.build(cabecera, registro_alta_xml)

      # Validación del XML contra el esquema XSD
      validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml.root.to_xml)

      expect(validate_schema[:valid]).to be true

    end

  end
end
