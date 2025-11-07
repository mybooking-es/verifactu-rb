module Verifactu
  class RegFactuSistemaFacturacionXmlBuilder
    #
    # It creates an XML representation of the RegFactuSistemaFacturacion.
    # xml.root.to_xml
    #
    # @param cabecera [Verifactu::Cabecera] The header information for the XML.
    # @param registro_alta_xml [Nokigiri::XML::Document] The XML document containing the RegistroAlta data.
    # @return [Nokogiri::XML::Document] The XML document representing the RegFactuSistemaFacturacion.
    #
    def self.build(cabecera, registro_alta_xml)

      raise Verifactu::VerifactuError, "cabecera must be an instance of Cabecera" unless cabecera.is_a?(Cabecera)
      raise Verifactu::VerifactuError, "registro_alta_xml must be an instance of Nokogiri::XML::Document" unless registro_alta_xml.is_a?(Nokogiri::XML::Document)

      # Create the XML document
      xml_document = Nokogiri::XML('<sum:RegFactuSistemaFacturacion/>')

      # Set the namespaces
      root = xml_document.root
      root.add_namespace_definition('sum', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroLR.xsd')
      root.add_namespace_definition('sum1', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd')
      root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      root['xsi:schemaLocation'] = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroLR.xsd SuministroLR.xsd'


      xml_document.encoding = 'UTF-8'

      # Add la cabecera
      agregar_cabecera(xml_document, cabecera)

      # Create the RegistroFactura node that will contain the high invoice records
      @registro_factura_element = Nokogiri::XML::Node.new('sum:RegistroFactura', xml_document)
      xml_document.root.add_child(@registro_factura_element)

      # Add the invoice record
      agregar_registro_alta(xml_document, registro_alta_xml)

      return xml_document

    end

    #
    # Add a high record to the XML
    #
    def self.agregar_registro_alta(xml_document, registro_alta_xml)

      raise Verifactu::VerifactuError, "registro_alta_xml must be an instance of Nokogiri::XML::Document" unless registro_alta_xml.is_a?(Nokogiri::XML::Document)
      @registro_factura_element.add_child(registro_alta_xml.root)
      return self

    end

    private

    #
    # Add la cabecera al XML.
    #
    def self.agregar_cabecera(xml_document, cabecera)

      cabecera_element = Nokogiri::XML::Node.new('sum:Cabecera', xml_document)

      # Obligado emision
      obligado_emision_element = Nokogiri::XML::Node.new('sum1:ObligadoEmision', xml_document)
      obligado_emision_razon_social_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document)
      obligado_emision_razon_social_element.content = cabecera.obligado_emision.business_name
      obligado_emision_element.add_child(obligado_emision_razon_social_element)
      obligado_emision_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document)
      obligado_emision_nif_element.content = cabecera.obligado_emision.nif
      obligado_emision_element.add_child(obligado_emision_nif_element)
      cabecera_element.add_child(obligado_emision_element)

      if cabecera.representante
        # Representante
        obligado_representante_element = Nokogiri::XML::Node.new('sum1:Representante', xml_document)
        obligado_representante_razon_social_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document)
        obligado_representante_razon_social_element.content = cabecera.representante.business_name
        obligado_representante_element.add_child(obligado_representante_razon_social_element)
        obligado_representante_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document)
        obligado_representante_nif_element.content = cabecera.representante.nif
        obligado_representante_element.add_child(obligado_representante_nif_element)
      end

      # Añade la cabecera al documento XML
      xml_document.root.add_child(cabecera_element)
    end

  end
end
