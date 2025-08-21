module Verifactu
  class RegFactuSistemaFacturacionXmlBuilder
    #
    # It creates an XML representation of the RegFactuSistemaFacturacion.
    # xml.root.to_xml
    #
    # @param cabecera [Verifactu::Cabecera] The header information for the XML.
    # @param filtro_consulta_xml [Nokigiri::XML::Document] The XML document containing the RegistroAlta data.
    # @return [Nokogiri::XML::Document] The XML document representing the RegFactuSistemaFacturacion.
    #
    def self.build(cabecera, filtro_consulta_xml, nombre_razon_emisor = false, sistema_informatico = false)

      raise Verifactu::VerifactuError, "cabecera must be an instance of CabeceraConsulta" unless cabecera.is_a?(Verifactu::ConsultaFactu::CabeceraConsulta)
      raise Verifactu::VerifactuError, "filtro_consulta_xml must be an instance of Nokogiri::XML::Document" unless filtro_consulta_xml.is_a?(Nokogiri::XML::Document)

      # Create the XML document
      xml_document = Nokogiri::XML('<sum:RegFactuSistemaFacturacion/>')

      # Set the namespaces
      root = xml_document.root
      root.add_namespace_definition('sum', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/ConsultaLR.xsd')
      root.add_namespace_definition('sum1', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd')
      root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      root['xsi:schemaLocation'] = 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/ConsultaLR.xsd ConsultaLR.xsd'

      xml_document.encoding = 'UTF-8'

      # Agrega la cabecera
      agregar_cabecera(xml_document, cabecera)

      # Crea el nodo RegistroFactura que contendrá los registros de factura alta
      @registro_factura_element = Nokogiri::XML::Node.new('sum:ConsultaFactuSistemaFacturacion', xml_document)
      xml_document.root.add_child(@registro_factura_element)

      # Agrega el registro de factura
      agregar_filtro_consulta(xml_document, filtro_consulta_xml)

      agregar_datos_adicionales(xml_document, nombre_razon_emisor, sistema_informatico) if nombre_razon_emisor || sistema_informatico
      return xml_document

    end

    #
    # Agrega un registro de alta al XML
    #
    def self.agregar_filtro_consulta(xml_document, filtro_consulta_xml)

      raise Verifactu::VerifactuError, "filtro_consulta_xml must be an instance of Nokogiri::XML::Document" unless filtro_consulta_xml.is_a?(Nokogiri::XML::Document)
      @registro_factura_element.add_child(filtro_consulta_xml.root)
      return self

    end

    private

    #
    # Agrega la cabecera al XML.
    #
    def self.agregar_cabecera(xml_document, cabecera)

      cabecera_element = Nokogiri::XML::Node.new('sum:Cabecera', xml_document)

      # id_version
      id_version_element = Nokogiri::XML::Node.new('sum:IDVersion', xml_document)
      id_version.content = cabecera.id_version
      cabecera_element.add_child(id_version_element)



      # Obligado emision
      if cabecera.obligado_emision
        obligado_emision_element = Nokogiri::XML::Node.new('sum1:ObligadoEmision', xml_document)
        obligado_emision_razon_social_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document)
        obligado_emision_razon_social_element.content = cabecera.obligado_emision.nombre_razon
        obligado_emision_element.add_child(obligado_emision_razon_social_element)
        obligado_emision_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document)
        obligado_emision_nif_element.content = cabecera.obligado_emision.nif
        obligado_emision_element.add_child(obligado_emision_nif_element)
        cabecera_element.add_child(obligado_emision_element)
      else #Destinatario
        destinatario_element = Nokogiri::XML::Node.new('sum1:Destinatario', xml_document)
        destinatario_razon_social_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document)
        destinatario_razon_social_element.content = cabecera.destinatario.nombre_razon
        destinatario_element.add_child(destinatario_razon_social_element)
        destinatario_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document)
        destinatario_nif_element.content = cabecera.destinatario.nif
        destinatario_element.add_child(destinatario_nif_element)
        cabecera_element.add_child(destinatario_element)
      end

      if cabecera.indicador_representante
        indicador_representante_element = Nokogiri::XML::new('sum1:IndicadorRepresentante', xml_document)
        indicador_representante_element.content = cabecera.indicador_representante
        cabecera_element.add_child(indicador_representante_element)
      end

      # Añade la cabecera al documento XML
      xml_document.root.add_child(cabecera_element)
    end

    #
    # Agrega datos adicionales de respuesta al XML.
    #
    def self.agregar_datos_adicionales(xml_document, nombre_razon_emisor, sistema_informatico)
      datos_adicionales_respuesta_element = Nokogiri::XML::Node.new('sum:DatosAdicionalesRespuesta', xml_document)
      # Agregar NombreRazonEmisor
      if nombre_razon_emisor
        nombre_razon_emisor_element = Nokogiri::XML::Node.new('sum1:NombreRazonEmisor', xml_document)
        nombre_razon_emisor_element.content = "S"
        datos_adicionales_respuesta_element.add_child(nombre_razon_emisor_element)
      end

      # Agregar SistemaInformatico
      if sistema_informatico
        sistema_informatico_element = Nokogiri::XML::Node.new('sum1:SistemaInformatico', xml_document)
        sistema_informatico_element.content = "S"
        datos_adicionales_respuesta_element.add_child(sistema_informatico_element)
      end

      xml_document.root.add_child(datos_adicionales_respuesta_element)
    end

  end
end
