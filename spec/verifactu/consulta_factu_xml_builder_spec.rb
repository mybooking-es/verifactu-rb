require 'spec_helper'


RSpec.describe Verifactu::ConsultaFactuXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegFactuSistemaFacturacion' do

      # Create la cabecera
      cabecera = cabecera_consulta_valida
      filtro_consulta = filtro_consulta_compleja_valida


      # Generate el XML de la consulta
      filtro_consulta_xml = Verifactu::FiltroConsultaXmlBuilder.build(filtro_consulta)

      # Generate el XML
      xml = Verifactu::ConsultaFactuXmlBuilder.build(cabecera: cabecera, filtro_consulta_xml: filtro_consulta_xml)
      #p "xml: #{xml.root.to_xml}"

      # Validación del XML contra el esquema XSD
      validate_schema = Verifactu::Helpers::ValidaConsultaXSD.execute(xml.root.to_xml)
      raise Verifactu::VerifactuError, "No valid! #{validate_schema[:errors]}" unless validate_schema[:valid]
      expect(validate_schema[:valid]).to be true

    end

  end
end
