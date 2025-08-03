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
      xml_document = Nokogiri::XML('<sum1:RegistroAlta/>')
      xml_document.encoding = 'UTF-8'

      agregar_registro_alta(xml_document.root, registro_alta)

      return xml_document

    end

    private

    #
    # Agrega un registro de alta al XML
    # @param xml_document_root [Nokogiri::XML::Node] The root node of the XML document.
    # @param registro [Verifactu::RegistroAlta] The RegistroAlta object to convert to XML.
    # @return [Nokogiri::XML::Node] The updated XML document root with the RegistroAlta data.
    #
    def self.agregar_registro_alta(xml_document_root, registro)


      # Agrega IdVersion
      id_version_element = Nokogiri::XML::Node.new('sum1:IDVersion', xml_document_root)
      id_version_element.content = Verifactu::Config::ID_VERSION
      xml_document_root.add_child(id_version_element)

      # Agrega IDFactura
      id_factura_element = Nokogiri::XML::Node.new('sum1:IDFactura', xml_document_root)
      id_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
      id_emisor_factura_element.content = registro.id_factura.id_emisor_factura
      id_factura_element.add_child(id_emisor_factura_element)
      num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
      num_serie_factura_element.content = registro.id_factura.num_serie_factura
      id_factura_element.add_child(num_serie_factura_element)
      fecha_expedicion_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
      fecha_expedicion_element.content = registro.id_factura.fecha_expedicion_factura
      id_factura_element.add_child(fecha_expedicion_element)
      xml_document_root.add_child(id_factura_element)

      # Agrega NombreRazonEmisor
      nombre_razon_emisor_element = Nokogiri::XML::Node.new('sum1:NombreRazonEmisor', xml_document_root)
      nombre_razon_emisor_element.content = registro.nombre_razon_emisor
      xml_document_root.add_child(nombre_razon_emisor_element)

      # Agrega TipoFactura
      tipo_factura_element = Nokogiri::XML::Node.new('sum1:TipoFactura', xml_document_root)
      tipo_factura_element.content = registro.tipo_factura
      xml_document_root.add_child(tipo_factura_element)

      # Agrega DescripcionOperacion
      descripcion_operacion_element = Nokogiri::XML::Node.new('sum1:DescripcionOperacion', xml_document_root)
      descripcion_operacion_element.content = registro.descripcion_operacion
      xml_document_root.add_child(descripcion_operacion_element)

      # Agregar tercero (es el presentador)
      if registro.tercero
        tercero_element = Nokogiri::XML::Node.new('sum1:Tercero', xml_document_root)
        tercero_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        tercero_nombre_razon_element.content = registro.tercero.nombre_razon
        tercero_element.add_child(tercero_nombre_razon_element)
        tercero_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        tercero_nif_element.content = registro.tercero.nif
        tercero_element.add_child(tercero_nif_element)
        xml_document_root.add_child(tercero_element)
      end

      # Agregar destinatarios
      destinatarios_element = Nokogiri::XML::Node.new('sum1:Destinatarios', xml_document_root)
      xml_document_root.add_child(destinatarios_element)
      registro.destinatarios.each do |destinatario|
        id_destinatario_element = Nokogiri::XML::Node.new('sum1:IDDestinatario', xml_document_root)
        nombre_destinatario_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        nombre_destinatario_element.content = destinatario.nombre_razon
        id_destinatario_element.add_child(nombre_destinatario_element)
        nif_destinatario_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        nif_destinatario_element.content = destinatario.nif
        id_destinatario_element.add_child(nif_destinatario_element)
        destinatarios_element.add_child(id_destinatario_element)
      end

      # Agrega Desgloses
      desglose_element = Nokogiri::XML::Node.new('sum1:Desglose', xml_document_root)
      xml_document_root.add_child(desglose_element)

      registro.desglose.each do |item|
        item_element = Nokogiri::XML::Node.new('sum1:DetalleDesglose', xml_document_root)
        desglose_element.add_child(item_element)

        # Agrega los detalles del desglose
        item_element.add_child(Nokogiri::XML::Node.new('sum1:Impuesto', xml_document_root).tap { |e| e.content = item.impuesto })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:ClaveRegimen', xml_document_root).tap { |e| e.content = item.clave_regimen })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:CalificacionOperacion', xml_document_root).tap { |e| e.content = item.calificacion_operacion })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:TipoImpositivo', xml_document_root).tap { |e| e.content = item.tipo_impositivo })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:BaseImponibleOimporteNoSujeto', xml_document_root).tap { |e| e.content = item.base_imponible_o_importe_no_sujeto })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:CuotaRepercutida', xml_document_root).tap { |e| e.content = item.cuota_repercutida })
      end

      # Agregar CuotaTotal
      cuota_total_element = Nokogiri::XML::Node.new('sum1:CuotaTotal', xml_document_root)
      cuota_total_element.content = registro.cuota_total
      xml_document_root.add_child(cuota_total_element)

      # Agregar ImporteTotal
      importe_total_element = Nokogiri::XML::Node.new('sum1:ImporteTotal', xml_document_root)
      importe_total_element.content = registro.importe_total
      xml_document_root.add_child(importe_total_element)

      # Agregar Encadenamiento
      encadenamiento_element = Nokogiri::XML::Node.new('sum1:Encadenamiento', xml_document_root)
      if registro.encadenamiento.primer_registro == 'S'
        encadenamiento_primer_registro_element = Nokogiri::XML::Node.new('sum1:PrimerRegistro', xml_document_root)
        encadenamiento_primer_registro_element.content = registro.encadenamiento.primer_registro
        encadenamiento_element.add_child(encadenamiento_primer_registro_element)
      else
        encadenamiento_registro_anterior_element = Nokogiri::XML::Node.new('sum1:RegistroAnterior', xml_document_root)
        encadenamiento_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
        encadenamiento_emisor_factura_element.content = registro.encadenamiento.id_emisor_factura
        encadenamiento_registro_anterior_element.add_child(encadenamiento_emisor_factura_element)
        encadenamiento_num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
        encadenamiento_num_serie_factura_element.content = registro.encadenamiento.num_serie_factura
        encadenamiento_registro_anterior_element.add_child(encadenamiento_num_serie_factura_element)
        encadenamiento_fecha_expedicion_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
        encadenamiento_fecha_expedicion_element.content = registro.encadenamiento.fecha_expedicion_factura
        encadenamiento_registro_anterior_element.add_child(encadenamiento_fecha_expedicion_element)
        encadenamiento_element.add_child(encadenamiento_registro_anterior_element)
        encadenamiento_huella_element = Nokogiri::XML::Node.new('sum1:Huella', xml_document_root)
        encadenamiento_huella_element.content = registro.encadenamiento.huella
        encadenamiento_element.add_child(encadenamiento_huella_element)
      end
      xml_document_root.add_child(encadenamiento_element)

      # Agregar SistemaInformatico
      sistema_informatico_element = Nokogiri::XML::Node.new('sum1:SistemaInformatico', xml_document_root)
      sistema_informatico_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
      sistema_informatico_nombre_razon_element.content = registro.sistema_informatico.nombre_razon
      sistema_informatico_element.add_child(sistema_informatico_nombre_razon_element)
      sistema_informatico_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
      sistema_informatico_nif_element.content = registro.sistema_informatico.nif
      sistema_informatico_element.add_child(sistema_informatico_nif_element)
      sistema_informatico_nombre_sistema_element = Nokogiri::XML::Node.new('sum1:NombreSistemaInformatico', xml_document_root)
      sistema_informatico_nombre_sistema_element.content = registro.sistema_informatico.nombre_sistema_informatico
      sistema_informatico_element.add_child(sistema_informatico_nombre_sistema_element)
      sistema_informatico_id_element = Nokogiri::XML::Node.new('sum1:IdSistemaInformatico', xml_document_root)
      sistema_informatico_id_element.content = registro.sistema_informatico.id_sistema_informatico
      sistema_informatico_element.add_child(sistema_informatico_id_element)
      sistema_informatico_version_element = Nokogiri::XML::Node.new('sum1:Version', xml_document_root)
      sistema_informatico_version_element.content = registro.sistema_informatico.version
      sistema_informatico_element.add_child(sistema_informatico_version_element)
      sistema_informatico_numero_instalacion_element = Nokogiri::XML::Node.new('sum1:NumeroInstalacion', xml_document_root)
      sistema_informatico_numero_instalacion_element.content = registro.sistema_informatico.numero_instalacion
      sistema_informatico_element.add_child(sistema_informatico_numero_instalacion_element)
      sistema_informatico_tipo_uso_posible_solo_verifactu_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleSoloVerifactu', xml_document_root)
      sistema_informatico_tipo_uso_posible_solo_verifactu_element.content = registro.sistema_informatico.tipo_uso_posible_solo_verifactu
      sistema_informatico_element.add_child(sistema_informatico_tipo_uso_posible_solo_verifactu_element)
      sistema_informatico_tipo_uso_posible_multi_ot_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleMultiOT', xml_document_root)
      sistema_informatico_tipo_uso_posible_multi_ot_element.content = registro.sistema_informatico.tipo_uso_posible_multi_ot
      sistema_informatico_element.add_child(sistema_informatico_tipo_uso_posible_multi_ot_element)
      sistema_informatico_indicador_multi_ot_element = Nokogiri::XML::Node.new('sum1:IndicadorMultiplesOT', xml_document_root)
      sistema_informatico_indicador_multi_ot_element.content = registro.sistema_informatico.indicador_multi_ot
      sistema_informatico_element.add_child(sistema_informatico_indicador_multi_ot_element)
      xml_document_root.add_child(sistema_informatico_element)

      # Agregar FechaHoraHusoGenRegistro
      fecha_hora_huso_gen_registro_element = Nokogiri::XML::Node.new('sum1:FechaHoraHusoGenRegistro', xml_document_root)
      fecha_hora_huso_gen_registro_element.content = registro.fecha_hora_huso_gen_registro
      xml_document_root.add_child(fecha_hora_huso_gen_registro_element)

      # Agregar TipoHuella
      tipo_huella_element = Nokogiri::XML::Node.new('sum1:TipoHuella', xml_document_root)
      tipo_huella_element.content = registro.tipo_huella
      xml_document_root.add_child(tipo_huella_element)

      # Agregar Huella
      huella_element = Nokogiri::XML::Node.new('sum1:Huella', xml_document_root)
      huella_element.content = registro.huella
      xml_document_root.add_child(huella_element)

      return xml_document_root

    end

  end
end
