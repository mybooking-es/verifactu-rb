module Verifactu
  #
  # This class is responsible for building the XML representation of a RegistroAlta.
  #
  class RegistroAltaXmlBuilder

    #
    # It creates an XML representation of the RegistroAlta.
    # (xml.root.to_xml)
    #
    # @param registro_alta [Verifactu::RegistroAlta] The RegistroAlta object to convert to XML.
    # @return [Nokogiri::XML::Document] The XML document representing the RegistroAlta.
    #
    def self.build(registro_alta)

      # Create the XML document
      xml_document = Nokogiri::XML::Document.new
      xml_document.encoding = 'UTF-8'

      # Crear nodo raíz con namespace
      root = Nokogiri::XML::Node.new('sum1:FiltroConsulta', xml_document)
      root.add_namespace_definition('sum1', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd')
      xml_document.root = root

      agregar_filtro_consulta(root, registro_alta)

      return xml_document

    end

    private

    #
    # Agrega un registro de alta al XML
    # @param xml_document_root [Nokogiri::XML::Node] The root node of the XML document.
    # @param registro [Verifactu::RegistroAlta] The RegistroAlta object to convert to XML.
    # @return [Nokogiri::XML::Node] The updated XML document root with the RegistroAlta data.
    #
    def self.agregar_filtro_consulta(xml_document_root, filtro_consulta)

      
      # Agrega Periodo imputacion
      periodo_imputacion_element = Nokogiri::XML::Node.new('sum1:PeriodoImputacion', xml_document_root)

      ejercicio_periodo_element = Nokogiri::XML::Node.new('sum1:Ejercicio', xml_document_root)
      ejercicio_periodo_element.content = filtro_consulta.periodo_imputacion.ejercicio
      periodo_imputacion_element.add_child(ejercicio_periodo_element)

      periodo_periodo_imputacion_element = Nokogiri::XML::Node.new('sum1:Periodo', xml_document_root)
      periodo_periodo_imputacion_element.content = filtro_consulta.periodo_imputacion.periodo
      periodo_imputacion_element.add_child(periodo_periodo_imputacion_element)
      
      xml_document_root.add_child(periodo_imputacion_element)


      # Agrega NumSerieFactura
      if filtro_consulta.num_serie_factura
        num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
        num_serie_factura_element.content = filtro_consulta.num_serie_factura
        xml_document_root.add_child(num_serie_factura_element)
      end

      # Agregar Contraparte
      if registro.contraparte
        contraparte_element = Nokogiri::XML::Node.new('sum1:Contraparte', xml_document_root)
        contraparte_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        contraparte_nombre_razon_element.content = filtro_consulta.contraparte.nombre_razon
        contraparte_element.add_child(contraparte_nombre_razon_element)
        contraparte_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        contraparte_nif_element.content = filtro_consulta.contraparte.nif
        contraparte_element.add_child(contraparte_nif_element)
        xml_document_root.add_child(contraparte_element)
      end

      # Agregar FechaExpedicionFactura
      if filtro_consulta.fecha_expedicion_factura
        fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
        
        if filtro_consulta.fecha_expedicion_factura.fecha_expedicion
          fecha_expedicion_factura_element.content = filtro_consulta.fecha_expedicion_factura.fecha_expedicion
        else
          rango_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:RangoFechaExpedicion', xml_document_root)

          desde_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:Desde', xml_document_root)
          desde_fecha_expedicion_factura_element.content = filtro_consulta.fecha_expedicion_factura.desde
          rango_fecha_expedicion_factura_element.add_child(desde_fecha_expedicion_factura_element)

          hasta_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:Hasta', xml_document_root)
          hasta_fecha_expedicion_factura_element.content = filtro_consulta.fecha_expedicion_factura.hasta
          rango_fecha_expedicion_factura_element.add_child(hasta_fecha_expedicion_factura_element)

          fecha_expedicion_factura_element.add_child(rango_fecha_expedicion_factura_element)
        end
        
        xml_document_root.add_child(fecha_expedicion_factura_element)
      end

      # Agregar SistemaInformatico
      if filtro_consulta.sistema_informatico
        sistema_informatico_element = Nokogiri::XML::Node.new('sum1:SistemaInformatico', xml_document_root)
        sistema_informatico_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        sistema_informatico_nombre_razon_element.content = filtro_consulta.sistema_informatico.nombre_razon
        sistema_informatico_element.add_child(sistema_informatico_nombre_razon_element)
        sistema_informatico_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        sistema_informatico_nif_element.content = filtro_consulta.sistema_informatico.nif
        sistema_informatico_element.add_child(sistema_informatico_nif_element)
        sistema_informatico_nombre_sistema_element = Nokogiri::XML::Node.new('sum1:NombreSistemaInformatico', xml_document_root)
        sistema_informatico_nombre_sistema_element.content = filtro_consulta.sistema_informatico.nombre_sistema_informatico
        sistema_informatico_element.add_child(sistema_informatico_nombre_sistema_element)
        sistema_informatico_id_element = Nokogiri::XML::Node.new('sum1:IdSistemaInformatico', xml_document_root)
        sistema_informatico_id_element.content = filtro_consulta.sistema_informatico.id_sistema_informatico
        sistema_informatico_element.add_child(sistema_informatico_id_element)
        sistema_informatico_version_element = Nokogiri::XML::Node.new('sum1:Version', xml_document_root)
        sistema_informatico_version_element.content = filtro_consulta.sistema_informatico.version
        sistema_informatico_element.add_child(sistema_informatico_version_element)
        sistema_informatico_numero_instalacion_element = Nokogiri::XML::Node.new('sum1:NumeroInstalacion', xml_document_root)
        sistema_informatico_numero_instalacion_element.content = filtro_consulta.sistema_informatico.numero_instalacion
        sistema_informatico_element.add_child(sistema_informatico_numero_instalacion_element)
        sistema_informatico_tipo_uso_posible_solo_verifactu_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleSoloVerifactu', xml_document_root)
        sistema_informatico_tipo_uso_posible_solo_verifactu_element.content = filtro_consulta.sistema_informatico.tipo_uso_posible_solo_verifactu
        sistema_informatico_element.add_child(sistema_informatico_tipo_uso_posible_solo_verifactu_element)
        sistema_informatico_tipo_uso_posible_multi_ot_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleMultiOT', xml_document_root)
        sistema_informatico_tipo_uso_posible_multi_ot_element.content = filtro_consulta.sistema_informatico.tipo_uso_posible_multi_ot
        sistema_informatico_element.add_child(sistema_informatico_tipo_uso_posible_multi_ot_element)
        sistema_informatico_indicador_multiples_ot_element = Nokogiri::XML::Node.new('sum1:IndicadorMultiplesOT', xml_document_root)
        sistema_informatico_indicador_multiples_ot_element.content = filtro_consulta.sistema_informatico.indicador_multiples_ot
        sistema_informatico_element.add_child(sistema_informatico_indicador_multiples_ot_element)
        xml_document_root.add_child(sistema_informatico_element)
      end

      # Agregar ClavePaginacion
      if filtro_consulta.clave_paginacion
        clave_paginacion_element = Nokogiri::XML::Node.new('sum1:ClavePaginacion', xml_document_root)
        
        id_emisor_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum1:IdEmisorFactura', xml_document_root)
        id_emisor_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.id_emisor_factura
        clave_paginacion_element.add_child(id_emisor_factura_clave_paginacion_element)

        num_serie_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
        num_serie_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.num_serie_factura
        clave_paginacion_element.add_child(num_serie_factura_clave_paginacion_element)

        fecha_expedicion_factura_clave_paginacion_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
        fecha_expedicion_factura_clave_paginacion_element.content = filtro_consulta.clave_paginacion.fecha_expedicion_factura
        clave_paginacion_element.add_child(fecha_expedicion_factura_clave_paginacion_element)

        xml_document_root.add_child(clave_paginacion_element)
      end

      return xml_document_root

    end

  end
end
