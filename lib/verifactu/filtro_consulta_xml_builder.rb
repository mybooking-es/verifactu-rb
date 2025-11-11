module Verifactu
  #
  # This class is responsible for building the XML representation of a RegistroAlta.
  #
  class FiltroConsultaXmlBuilder

    #
    # It creates an XML representation of the RegistroAlta.
    # (xml.root.to_xml)
    #
    # @param filtro [Verifactu::ConsultaFactu::FiltroConsulta] The FiltroConsulta object to convert to XML.
    # @return [Nokogiri::XML::Document] The XML document representing the FiltroConsulta.
    #
    def self.build(filtro_consulta)

      # Create the XML document
      xml_document = Nokogiri::XML::Document.new
      xml_document.encoding = 'UTF-8'

      # Create nodo raíz con namespace
      root = Nokogiri::XML::Node.new('con:FiltroConsulta', xml_document)
      root.add_namespace_definition('sum', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd')
      xml_document.root = root

      agregar_filtro_consulta(root, filtro_consulta)

      return xml_document

    end

    private

    #
    # Add a query filter to the XML
    # @param xml_document_root [Nokogiri::XML::Node] The root node of the XML document.
    # @param filtro_consulta [Verifactu::FiltroConsulta] The FiltroConsulta object to convert to XML.
    # @return [Nokogiri::XML::Node] The updated XML document root with the FiltroConsulta data.
    #
    def self.agregar_filtro_consulta(xml_document_root, filtro_consulta)


      # Add Periodo imputacion
      periodo_imputacion_element = Nokogiri::XML::Node.new('con:PeriodoImputacion', xml_document_root)

      ejercicio_periodo_element = Nokogiri::XML::Node.new('sum:Ejercicio', xml_document_root)
      ejercicio_periodo_element.content = filtro_consulta.periodo_imputacion.ejercicio
      periodo_imputacion_element.add_child(ejercicio_periodo_element)

      periodo_periodo_imputacion_element = Nokogiri::XML::Node.new('sum:Periodo', xml_document_root)
      periodo_periodo_imputacion_element.content = filtro_consulta.periodo_imputacion.periodo
      periodo_imputacion_element.add_child(periodo_periodo_imputacion_element)

      xml_document_root.add_child(periodo_imputacion_element)

      # Add NumSerieFactura
      if filtro_consulta.series_number
        num_serie_factura_element = Nokogiri::XML::Node.new('con:NumSerieFactura', xml_document_root)
        num_serie_factura_element.content = filtro_consulta.series_number
        xml_document_root.add_child(num_serie_factura_element)
      end

      # Add Contraparte
      if filtro_consulta.contraparte
        contraparte_element = Nokogiri::XML::Node.new('con:Contraparte', xml_document_root)
        contraparte_nombre_razon_element = Nokogiri::XML::Node.new('sum:NombreRazon', xml_document_root)
        contraparte_nombre_razon_element.content = filtro_consulta.contraparte.business_name
        contraparte_element.add_child(contraparte_nombre_razon_element)
        contraparte_nif_element = Nokogiri::XML::Node.new('sum:NIF', xml_document_root)
        contraparte_nif_element.content = filtro_consulta.contraparte.nif
        contraparte_element.add_child(contraparte_nif_element)
        xml_document_root.add_child(contraparte_element)
      end

      # Add FechaExpedicionFactura
      if filtro_consulta.issue_date
        fecha_expedicion_factura_element = Nokogiri::XML::Node.new('con:FechaExpedicionFactura', xml_document_root)

        if filtro_consulta.issue_date.fecha_expedicion
          fecha_expedicion_factura_sub_element = Nokogiri::XML::Node.new('sum:FechaExpedicionFactura', xml_document_root)
          fecha_expedicion_factura_sub_element.content = filtro_consulta.issue_date.fecha_expedicion
          fecha_expedicion_factura_element.add_child(fecha_expedicion_factura_sub_element)
        else
          rango_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum:RangoFechaExpedicion', xml_document_root)

          desde_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum:Desde', xml_document_root)
          desde_fecha_expedicion_factura_element.content = filtro_consulta.issue_date.desde
          rango_fecha_expedicion_factura_element.add_child(desde_fecha_expedicion_factura_element)

          hasta_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum:Hasta', xml_document_root)
          hasta_fecha_expedicion_factura_element.content = filtro_consulta.issue_date.hasta
          rango_fecha_expedicion_factura_element.add_child(hasta_fecha_expedicion_factura_element)

          fecha_expedicion_factura_element.add_child(rango_fecha_expedicion_factura_element)
        end

        xml_document_root.add_child(fecha_expedicion_factura_element)
      end

      # Add SistemaInformatico
      if filtro_consulta.information_system
        sistema_informatico_element = Nokogiri::XML::Node.new('con:SistemaInformatico', xml_document_root)
        sistema_informatico_nombre_razon_element = Nokogiri::XML::Node.new('sum:NombreRazon', xml_document_root)
        sistema_informatico_nombre_razon_element.content = filtro_consulta.information_system.business_name
        sistema_informatico_element.add_child(sistema_informatico_nombre_razon_element)
        sistema_informatico_nif_element = Nokogiri::XML::Node.new('sum:NIF', xml_document_root)
        sistema_informatico_nif_element.content = filtro_consulta.information_system.nif
        sistema_informatico_element.add_child(sistema_informatico_nif_element)
        sistema_informatico_nombre_sistema_element = Nokogiri::XML::Node.new('sum:NombreSistemaInformatico', xml_document_root)
        sistema_informatico_nombre_sistema_element.content = filtro_consulta.information_system.nombre_sistema_informatico
        sistema_informatico_element.add_child(sistema_informatico_nombre_sistema_element)
        sistema_informatico_id_element = Nokogiri::XML::Node.new('sum:IdSistemaInformatico', xml_document_root)
        sistema_informatico_id_element.content = filtro_consulta.information_system.id_sistema_informatico
        sistema_informatico_element.add_child(sistema_informatico_id_element)
        sistema_informatico_version_element = Nokogiri::XML::Node.new('sum:Version', xml_document_root)
        sistema_informatico_version_element.content = filtro_consulta.information_system.version
        sistema_informatico_element.add_child(sistema_informatico_version_element)
        sistema_informatico_installation_number_element = Nokogiri::XML::Node.new('sum:NumeroInstalacion', xml_document_root)
        sistema_informatico_installation_number_element.content = filtro_consulta.information_system.installation_number
        sistema_informatico_element.add_child(sistema_informatico_installation_number_element)
        sistema_informatico_usage_type_verifactu_only_element = Nokogiri::XML::Node.new('sum:TipoUsoPosibleSoloVerifactu', xml_document_root)
        sistema_informatico_usage_type_verifactu_only_element.content = filtro_consulta.information_system.usage_type_verifactu_only
        sistema_informatico_element.add_child(sistema_informatico_usage_type_verifactu_only_element)
        sistema_informatico_usage_type_multi_ot_element = Nokogiri::XML::Node.new('sum:TipoUsoPosibleMultiOT', xml_document_root)
        sistema_informatico_usage_type_multi_ot_element.content = filtro_consulta.information_system.usage_type_multi_ot
        sistema_informatico_element.add_child(sistema_informatico_usage_type_multi_ot_element)
        sistema_informatico_multiple_ot_indicator_element = Nokogiri::XML::Node.new('sum:IndicadorMultiplesOT', xml_document_root)
        sistema_informatico_multiple_ot_indicator_element.content = filtro_consulta.information_system.multiple_ot_indicator
        sistema_informatico_element.add_child(sistema_informatico_multiple_ot_indicator_element)
        xml_document_root.add_child(sistema_informatico_element)
      end

      # Add ClavePaginacion
      if filtro_consulta.clave_paginacion
        clave_paginacion_element = Nokogiri::XML::Node.new('con:ClavePaginacion', xml_document_root)

        id_emisor_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum:IdEmisorFactura', xml_document_root)
        id_emisor_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.issuer_id
        clave_paginacion_element.add_child(id_emisor_factura_clave_paginacion_element)

        num_serie_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum:NumSerieFactura', xml_document_root)
        num_serie_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.series_number
        clave_paginacion_element.add_child(num_serie_factura_clave_paginacion_element)

        fecha_expedicion_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum:FechaExpedicionFactura', xml_document_root)
        fecha_expedicion_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.issue_date
        clave_paginacion_element.add_child(fecha_expedicion_factura_clave_paginacion_element)

        xml_document_root.add_child(clave_paginacion_element)
      end

      return xml_document_root

    end

  end
end
