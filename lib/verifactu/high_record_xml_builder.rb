module Verifactu
  #
  # This class is responsible for building the XML representation of a RegistroAlta.
  #
  class HighRecordXmlBuilder

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

      # Create root node with namespace
      root = Nokogiri::XML::Node.new('sum1:RegistroAlta', xml_document)
      root.add_namespace_definition('sum1', 'https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd')
      xml_document.root = root

      add_high_record(root, registro_alta)

      return xml_document

    end

    private

    #
    # Adds a high record to the XML
    # @param xml_document_root [Nokogiri::XML::Node] The root node of the XML document.
    # @param registro [Verifactu::HighRecord] The HighRecord object to convert to XML.
    # @return [Nokogiri::XML::Node] The updated XML document root with the RegistroAlta data.
    #
    def self.add_high_record(xml_document_root, registro)


      # Add IdVersion
      id_version_element = Nokogiri::XML::Node.new('sum1:IDVersion', xml_document_root)
      id_version_element.content = Verifactu::Config::ID_VERSION
      xml_document_root.add_child(id_version_element)

      # Add IDFactura
      id_factura_element = Nokogiri::XML::Node.new('sum1:IDFactura', xml_document_root)
      id_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
      id_emisor_factura_element.content = registro.invoice_id.issuer_id
      id_factura_element.add_child(id_emisor_factura_element)
      num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
      num_serie_factura_element.content = registro.invoice_id.series_number
      id_factura_element.add_child(num_serie_factura_element)
      fecha_expedicion_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
      fecha_expedicion_element.content = registro.invoice_id.issue_date
      id_factura_element.add_child(fecha_expedicion_element)
      xml_document_root.add_child(id_factura_element)

      # Add NombreRazonEmisor
      issuer_name_element = Nokogiri::XML::Node.new('sum1:NombreRazonEmisor', xml_document_root)
      issuer_name_element.content = registro.issuer_name
      xml_document_root.add_child(issuer_name_element)

      # Add TipoFactura
      tipo_factura_element = Nokogiri::XML::Node.new('sum1:TipoFactura', xml_document_root)
      tipo_factura_element.content = registro.invoice_type
      xml_document_root.add_child(tipo_factura_element)

      # Add Rectificativa
      if ['R1','R2','R3','R4','R5'].include?(registro.invoice_type)
        # Rectification type
        tipo_factura_rectificativa_element = Nokogiri::XML::Node.new('sum1:TipoRectificativa', xml_document_root)
        tipo_factura_rectificativa_element.content = registro.tipo_rectificativa
        xml_document_root.add_child(tipo_factura_rectificativa_element)
        if registro.facturas_rectificadas and registro.facturas_rectificadas.size > 0
          facturas_rectificadas_element = Nokogiri::XML::Node.new('sum1:FacturasRectificadas', xml_document_root)
          xml_document_root.add_child(facturas_rectificadas_element)
          registro.facturas_rectificadas.each do |factura_rectificada|
            id_factura_rectificada_element = Nokogiri::XML::Node.new('sum1:IDFacturaRectificada', xml_document_root)
            id_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
            id_emisor_factura_element.content = factura_rectificada.issuer_id
            id_factura_rectificada_element.add_child(id_emisor_factura_element)
            id_num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
            id_num_serie_factura_element.content = factura_rectificada.series_number
            id_factura_rectificada_element.add_child(id_num_serie_factura_element)
            id_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
            id_fecha_expedicion_factura_element.content = factura_rectificada.issue_date
            id_factura_rectificada_element.add_child(id_fecha_expedicion_factura_element)
            facturas_rectificadas_element.add_child(id_factura_rectificada_element)
          end
        end
        # Replaced invoices
        if registro.tipo_rectificativa == 'S'
          # Rectification amount (only for rectifications by substitution)
          if registro.importe_rectificacion
            importe_rectificacion_element = Nokogiri::XML::Node.new('sum1:ImporteRectificacion', xml_document_root)
            base_rectificada_element = Nokogiri::XML::Node.new('sum1:BaseRectificada', xml_document_root)
            base_rectificada_element.content = registro.importe_rectificacion.base_rectificada
            importe_rectificacion_element.add_child(base_rectificada_element)
            cuota_rectificada_element = Nokogiri::XML::Node.new('sum1:CuotaRectificada', xml_document_root)
            cuota_rectificada_element.content = registro.importe_rectificacion.cuota_rectificada
            importe_rectificacion_element.add_child(cuota_rectificada_element)
            xml_document_root.add_child(importe_rectificacion_element)
          end
        end
      end

      if registro.invoice_type == 'F3'
        if registro.facturas_sustituidas and registro.facturas_sustituidas.size > 0
          facturas_sustituidas_element = Nokogiri::XML::Node.new('sum1:FacturasSustituidas', xml_document_root)
          xml_document_root.add_child(facturas_sustituidas_element)
          registro.facturas_sustituidas.each do |factura_sustituida|
            id_factura_sustituida_element = Nokogiri::XML::Node.new('sum1:IDFacturaSustituida', xml_document_root)
            id_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
            id_emisor_factura_element.content = factura_sustituida.issuer_id
            id_factura_sustituida_element.add_child(id_emisor_factura_element)
            id_num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
            id_num_serie_factura_element.content = factura_sustituida.series_number
            id_factura_sustituida_element.add_child(id_num_serie_factura_element)
            id_fecha_expedicion_factura_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
            id_fecha_expedicion_factura_element.content = factura_sustituida.issue_date
            id_factura_sustituida_element.add_child(id_fecha_expedicion_factura_element)
            facturas_sustituidas_element.add_child(id_factura_sustituida_element)
          end
        end
      end

      # Add DescripcionOperacion
      descripcion_operacion_element = Nokogiri::XML::Node.new('sum1:DescripcionOperacion', xml_document_root)
      descripcion_operacion_element.content = registro.operation_description
      xml_document_root.add_child(descripcion_operacion_element)

      # Add third party (the presenter)
      if registro.third_party
        tercero_element = Nokogiri::XML::Node.new('sum1:Tercero', xml_document_root)
        tercero_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        tercero_nombre_razon_element.content = registro.third_party.nombre_razon
        tercero_element.add_child(tercero_nombre_razon_element)
        tercero_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        tercero_nif_element.content = registro.third_party.nif
        tercero_element.add_child(tercero_nif_element)
        xml_document_root.add_child(tercero_element)
      end

      # Add recipients
      destinatarios_element = Nokogiri::XML::Node.new('sum1:Destinatarios', xml_document_root)
      xml_document_root.add_child(destinatarios_element)
      registro.recipients.each do |destinatario|
        id_destinatario_element = Nokogiri::XML::Node.new('sum1:IDDestinatario', xml_document_root)
        nombre_destinatario_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
        nombre_destinatario_element.content = destinatario.business_name
        id_destinatario_element.add_child(nombre_destinatario_element)
        nif_destinatario_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
        nif_destinatario_element.content = destinatario.nif
        id_destinatario_element.add_child(nif_destinatario_element)
        destinatarios_element.add_child(id_destinatario_element)
      end

      # Add breakdown details
      desglose_element = Nokogiri::XML::Node.new('sum1:Desglose', xml_document_root)
      xml_document_root.add_child(desglose_element)

      registro.breakdown.each do |item|
        item_element = Nokogiri::XML::Node.new('sum1:DetalleDesglose', xml_document_root)
        desglose_element.add_child(item_element)

        # Add breakdown item details
        item_element.add_child(Nokogiri::XML::Node.new('sum1:Impuesto', xml_document_root).tap { |e| e.content = item.impuesto })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:ClaveRegimen', xml_document_root).tap { |e| e.content = item.regime_key })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:CalificacionOperacion', xml_document_root).tap { |e| e.content = item.operation_qualification })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:TipoImpositivo', xml_document_root).tap { |e| e.content = item.tax_rate })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:BaseImponibleOimporteNoSujeto', xml_document_root).tap { |e| e.content = item.taxable_base_o_importe_no_sujeto })
        item_element.add_child(Nokogiri::XML::Node.new('sum1:CuotaRepercutida', xml_document_root).tap { |e| e.content = item.charged_tax })
      end

      # Add total tax
      cuota_total_element = Nokogiri::XML::Node.new('sum1:CuotaTotal', xml_document_root)
      cuota_total_element.content = registro.total_tax
      xml_document_root.add_child(cuota_total_element)

      # Add total amount
      importe_total_element = Nokogiri::XML::Node.new('sum1:ImporteTotal', xml_document_root)
      importe_total_element.content = registro.total_amount
      xml_document_root.add_child(importe_total_element)

      # Add chaining
      encadenamiento_element = Nokogiri::XML::Node.new('sum1:Encadenamiento', xml_document_root)
      if registro.chaining.first_record == 'S'
        encadenamiento_primer_registro_element = Nokogiri::XML::Node.new('sum1:PrimerRegistro', xml_document_root)
        encadenamiento_primer_registro_element.content = registro.chaining.first_record
        encadenamiento_element.add_child(encadenamiento_primer_registro_element)
      else
        encadenamiento_registro_anterior_element = Nokogiri::XML::Node.new('sum1:RegistroAnterior', xml_document_root)
        encadenamiento_emisor_factura_element = Nokogiri::XML::Node.new('sum1:IDEmisorFactura', xml_document_root)
        encadenamiento_emisor_factura_element.content = registro.chaining.issuer_id
        encadenamiento_registro_anterior_element.add_child(encadenamiento_emisor_factura_element)
        encadenamiento_num_serie_factura_element = Nokogiri::XML::Node.new('sum1:NumSerieFactura', xml_document_root)
        encadenamiento_num_serie_factura_element.content = registro.chaining.series_number
        encadenamiento_registro_anterior_element.add_child(encadenamiento_num_serie_factura_element)
        encadenamiento_fecha_expedicion_element = Nokogiri::XML::Node.new('sum1:FechaExpedicionFactura', xml_document_root)
        encadenamiento_fecha_expedicion_element.content = registro.chaining.issue_date
        encadenamiento_registro_anterior_element.add_child(encadenamiento_fecha_expedicion_element)
        encadenamiento_huella_element = Nokogiri::XML::Node.new('sum1:Huella', xml_document_root)
        encadenamiento_huella_element.content = registro.chaining.fingerprint
        encadenamiento_registro_anterior_element.add_child(encadenamiento_huella_element)
        encadenamiento_element.add_child(encadenamiento_registro_anterior_element)
      end
      xml_document_root.add_child(encadenamiento_element)

      # Add information system
      information_system_element = Nokogiri::XML::Node.new('sum1:SistemaInformatico', xml_document_root)
      information_system_nombre_razon_element = Nokogiri::XML::Node.new('sum1:NombreRazon', xml_document_root)
      information_system_nombre_razon_element.content = registro.information_system.business_name
      information_system_element.add_child(information_system_nombre_razon_element)
      information_system_nif_element = Nokogiri::XML::Node.new('sum1:NIF', xml_document_root)
      information_system_nif_element.content = registro.information_system.nif
      information_system_element.add_child(information_system_nif_element)
      information_system_nombre_sistema_element = Nokogiri::XML::Node.new('sum1:NombreSistemaInformatico', xml_document_root)
      information_system_nombre_sistema_element.content = registro.information_system.system_name
      information_system_element.add_child(information_system_nombre_sistema_element)
      information_system_id_element = Nokogiri::XML::Node.new('sum1:IdSistemaInformatico', xml_document_root)
      information_system_id_element.content = registro.information_system.system_id
      information_system_element.add_child(information_system_id_element)
      information_system_version_element = Nokogiri::XML::Node.new('sum1:Version', xml_document_root)
      information_system_version_element.content = registro.information_system.version
      information_system_element.add_child(information_system_version_element)
      information_system_installation_number_element = Nokogiri::XML::Node.new('sum1:NumeroInstalacion', xml_document_root)
      information_system_installation_number_element.content = registro.information_system.installation_number
      information_system_element.add_child(information_system_installation_number_element)
      information_system_usage_type_verifactu_only_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleSoloVerifactu', xml_document_root)
      information_system_usage_type_verifactu_only_element.content = registro.information_system.usage_type_verifactu_only
      information_system_element.add_child(information_system_usage_type_verifactu_only_element)
      information_system_usage_type_multi_ot_element = Nokogiri::XML::Node.new('sum1:TipoUsoPosibleMultiOT', xml_document_root)
      information_system_usage_type_multi_ot_element.content = registro.information_system.usage_type_multi_ot
      information_system_element.add_child(information_system_usage_type_multi_ot_element)
      information_system_multiple_ot_indicator_element = Nokogiri::XML::Node.new('sum1:IndicadorMultiplesOT', xml_document_root)
      information_system_multiple_ot_indicator_element.content = registro.information_system.multiple_ot_indicator
      information_system_element.add_child(information_system_multiple_ot_indicator_element)
      xml_document_root.add_child(information_system_element)

      # Add record generation datetime with timezone
      fecha_hora_huso_gen_registro_element = Nokogiri::XML::Node.new('sum1:FechaHoraHusoGenRegistro', xml_document_root)
      fecha_hora_huso_gen_registro_element.content = registro.record_generation_datetime
      xml_document_root.add_child(fecha_hora_huso_gen_registro_element)

      # Add fingerprint type
      tipo_huella_element = Nokogiri::XML::Node.new('sum1:TipoHuella', xml_document_root)
      tipo_huella_element.content = registro.fingerprint_type
      xml_document_root.add_child(tipo_huella_element)

      # Add fingerprint
      huella_element = Nokogiri::XML::Node.new('sum1:Huella', xml_document_root)
      huella_element.content = registro.fingerprint
      xml_document_root.add_child(huella_element)

      return xml_document_root

    end

  end
end
