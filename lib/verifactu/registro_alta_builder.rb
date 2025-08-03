module Verifactu
  #
  # It is a builder for creating instances of RegistroAlta.
  #
  # @example
  #
  # Create a RegistroAlta instance with the required fields
  #
  #  registro_alta = Verifactu::RegistroAltaBuilder.new
  #    .con_id_factura('B12345674', 'NC202500051', '22-07-2025')
  #    .con_nombre_razon_emisor('Mi empresa SL')
  #    .con_tipo_factura('F1')
  #    .con_descripcion_operacion('Factura Reserva 2.731 - 22/07/2025 10:00 - 22/10/2025 10:00 - AAA-0009')
  #    .agregar_destinatario_nif(nombre_razon: 'Brad Stark', nif: '55555555K')
  #    .agregar_detalle_desglose(impuesto: '01', clave_regimen: '01', calificacion_operacion: 'S1',
  #                              cuota_repercutida: '55.54')
  #    .con_cuota_total('55.54')
  #                              tipo_impositivo: '21', base_imponible_o_importe_no_sujeto: '264.46',
  #    .con_importe_total('320.00')
  #    .con_encadenamiento_primer_registro
  #    .con_sistema_informatico(nombre_razon: 'Mi empresa SL', nif: 'B12345674',
  #                             nombre_sistema_informatico: 'Mi sistema', id_sistema_informatico: 'MB',
  #                             version: '1.0.0', numero_instalacion: 'Instalación 1',
  #                             tipo_uso_posible_solo_verifactu: 'S', tipo_uso_posible_multi_ot: 'S',
  #                             indicador_multi_ot: 'S')
  #    .con_fecha_hora_huso_gen_registro('2025-07-22T10:00:00+02:00')
  #    .con_tipo_huella('01')
  #    .con_huella(huella)
  #    .build
  #
  # Build the XML representation of the RegistroAlta
  #
  #  xml = Verifactu::RegistroAltaXmlBuilder.build(registro_alta)
  #
  class RegistroAltaBuilder

    def initialize
      @destinatarios = []
      @desglose = []
      @factura_rectificada = []
      @factura_substituida = []
      @subsanacion = 'N'
      @rechazo_previo = 'N'
      @descripcion_operacion = Verifactu::Config::DESCRIPCION_OPERACION_DEFECTO
      @macrodato = 'N'
      @cupon = 'N'
      @emitida_por_tercero_o_destinatario = 'D'
    end

    #
    # Set the IDFactura for the invoice. (required)
    #
    def con_id_factura(id_emisor, num_serie, fecha_expedicion)
      @id_factura = Verifactu::RegistroFacturacion::IDFactura.new(id_emisor_factura: id_emisor,
                                             num_serie_factura: num_serie,
                                             fecha_expedicion_factura: fecha_expedicion)
      self
    end

    #
    # Set the external reference for the invoice. (optional)
    #
    def con_ref_externa(ref_externa)
      @ref_externa = ref_externa
      self
    end

    #
    # Set the name or the issuer. (required)
    #
    def con_nombre_razon_emisor(nombre_razon)
      @nombre_razon_emisor = nombre_razon
      self
    end

    def con_subsanacion(subsanacion = 'S')
      @subsanacion = subsanacion
      self
    end

    def con_rechazo_previo(rechazo_previo = 'S')
      @rechazo_previo = rechazo_previo
      self
    end

    #
    # Set the invoice type. (required)
    # @param tipo_factura [String] The type of the invoice, e.g., 'F1' for ordinary invoice.
    #
    def con_tipo_factura(tipo_factura)
      @tipo_factura = tipo_factura
      self
    end

    def con_tipo_rectificativa(tipo_rectificativa)
      @tipo_rectificativa = tipo_rectificativa
      self
    end

    def agregar_factura_rectificada(id_emisor, num_serie, fecha_expedicion)
      @factura_rectificada << Verifactu::RegistroFacturacion::IDFactura.new(id_emisor: id_emisor, num_serie: num_serie, fecha_expedicion: fecha_expedicion)
      self
    end

    def agregar_factura_substituida(id_emisor, num_serie, fecha_expedicion)
      @factura_substituida << Verifactu::RegistroFacturacion::IDFactura.new(id_emisor: id_emisor, num_serie: num_serie, fecha_expedicion: fecha_expedicion)
      self
    end

    def con_importe_rectificacion(base_rectificada, cuota_rectificada, cuota_recargo_rectificada = nil)
      @importe_rectificacion = Verifactu::RegistroFacturacion::ImporteRectificacion.new(base_rectificada: base_rectificada, cuota_rectificada: cuota_rectificada, cuota_recargo_rectificada: cuota_recargo_rectificada)
      self
    end

    def con_fecha_operacion(fecha_operacion)
      @fecha_operacion = fecha_operacion
      self
    end

    def con_descripcion_operacion(descripcion_operacion)
      @descripcion_operacion = descripcion_operacion
      self
    end

    def factura_simplificada_Art7273(valor = 'S')
      @factura_simplificada_Art7273 = valor
      self
    end

    def factura_sin_identificar_destinatario_Art61d(valor = 'S')
      @factura_sin_identificar_destinatario_Art61d = valor
      self
    end

    def con_macrodato(macrodato = 'S')
      @macrodato = macrodato
      self
    end

    def emitida_por_tercero_o_destinatario(valor = 'D')
      @emitida_por_tercero_o_destinatario = valor
      self
    end

    def con_tercero_con_nif(nombre_razon, identificacion)
      @tercero = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(nombre_razon: nombre_razon, nif: identificacion)
      self
    end

    def con_tercero_con_id_otro(nombre_razon, codigo_pais, id_type, id)
      @id_otro = Verifactu::RegistroFacturacion::IDOtro.new(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @tercero = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_id_otro(nombre_razon: nombre_razon, id_otro: @id_otro)
      self
    end

    def agregar_destinatario_nif(nombre_razon:, nif:)
      @destinatarios << Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(nombre_razon: nombre_razon, nif: nif)
      self
    end

    def agregar_destinatario_id_otro(nombre_razon:, codigo_pais:, id_type:, id:)
      id_otro = Verifactu::RegistroFacturacion::IDOtro.new(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @destinatarios << Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_id_otro(nombre_razon: nombre_razon, id_otro: id_otro)
      self
    end

    #
    # Add a breakdown of the operation (e.g., VAT details).
    # @param clave_regimen [String] The tax regime key.
    # @param calificacion_operacion [String] The operation qualification (default is 'S1').
    # @param tipo_impositivo [String] The tax rate (e.g., '21' for 21%).
    # @param base_imponible_o_importe_no_sujeto [String] The taxable base or non-subject amount.
    # @param cuota_repercutida [String] The tax amount.
    #
    def agregar_detalle_desglose(impuesto: ,clave_regimen:, calificacion_operacion: , tipo_impositivo: ,
                                 base_imponible_o_importe_no_sujeto:, cuota_repercutida:,
                                 tipo_recargo_equivalencia: nil, cuota_recargo_equivalencia: nil)

      desglose_item = Verifactu::RegistroFacturacion::DetalleDesglose.create_operacion(
                                                impuesto: impuesto,
                                                clave_regimen: clave_regimen,
                                                calificacion_operacion: calificacion_operacion,
                                                tipo_impositivo: tipo_impositivo,
                                                base_imponible_o_importe_no_sujeto: base_imponible_o_importe_no_sujeto,
                                                cuota_repercutida: cuota_repercutida,
                                                tipo_recargo_equivalencia: tipo_recargo_equivalencia,
                                                cuota_recargo_equivalencia: cuota_recargo_equivalencia
                                             )

      @desglose << desglose_item
      self

    end

    def tiene_cupon(valor = 'S')
      @cupon = valor
      self
    end

    def con_cuota_total(cuota_total)
      @cuota_total = cuota_total
      self
    end

    def con_importe_total(importe_total)
      @importe_total = importe_total
      self
    end

    def primer_registro(valor = 'S')
      @primer_registro = valor
      self
    end

    def con_encadenamiento_primer_registro
      @encadenamiento = Verifactu::RegistroFacturacion::Encadenamiento.crea_encadenamiento_primer_registro
      self
    end

    def con_encadenamiento_registro_anterior(id_emisor, num_serie_factura, fecha_expedicion, huella_anterior)
      @encadenamiento = Verifactu::RegistroFacturacion::Encadenamiento.crea_encadenamiento_registro_anterior(
        id_emisor_factura: id_emisor,
        num_serie_factura: num_serie_factura,
        fecha_expedicion: fecha_expedicion,
        huella: huella_anterior
      )
      self
    end

    def con_sistema_informatico(nombre_razon:, nif:, nombre_sistema_informatico:, id_sistema_informatico:, version:, numero_instalacion:,
                   tipo_uso_posible_solo_verifactu:, tipo_uso_posible_multi_ot:, indicador_multi_ot:)
      @sistema_informatico = Verifactu::RegistroFacturacion::SistemaInformatico.new(nombre_razon: nombre_razon, nif: nif, nombre_sistema_informatico: nombre_sistema_informatico, id_sistema_informatico: id_sistema_informatico, version: version, numero_instalacion: numero_instalacion,
                   tipo_uso_posible_solo_verifactu: tipo_uso_posible_solo_verifactu, tipo_uso_posible_multi_ot: tipo_uso_posible_multi_ot, indicador_multi_ot: indicador_multi_ot)
      self
    end

    def con_fecha_hora_huso_gen_registro(fecha_hora_huso_gen_registro)
      @fecha_hora_huso_gen_registro = fecha_hora_huso_gen_registro
      self
    end

    def con_id_acuerdo_sistema_informatico(id_acuerdo_sistema_informatico)
      @id_acuerdo_sistema_informatico = id_acuerdo_sistema_informatico
      self
    end

    def con_tipo_huella(tipo_huella)
      @tipo_huella = tipo_huella
      self
    end

    def con_huella(huella)
      @huella = huella
      self
    end

    def con_signature(signature)
      @signature = signature
      self
    end

    def build
      Verifactu::RegistroFacturacion::RegistroAlta.new(
        id_factura: @id_factura,
        ref_externa: @ref_externa,
        nombre_razon_emisor: @nombre_razon_emisor,
        subsanacion: @subsanacion,
        rechazo_previo: @rechazo_previo,
        tipo_factura: @tipo_factura,
        tipo_rectificativa: @tipo_rectificativa,
        facturas_rectificativas: @facturas_rectificativas,
        facturas_sustituidas: @facturas_sustituidas,
        importe_rectificacion: @importe_rectificacion,
        fecha_operacion: @fecha_operacion,
        descripcion_operacion: @descripcion_operacion,
        factura_simplificada_Art7273: @factura_simplificada_Art7273,
        factura_sin_identif_destinatario_art61d: @factura_sin_identif_destinatario_Art61d,
        macrodato: @macrodato,
        emitida_por_tercero_o_destinatario: @emitida_por_tercero_o_destinatario,
        tercero: @tercero,
        destinatarios: @destinatarios,
        cupon: @cupon,
        desglose: @desglose,
        cuota_total: @cuota_total,
        importe_total: @importe_total,
        encadenamiento: @encadenamiento,
        sistema_informatico: @sistema_informatico,
        fecha_hora_huso_gen_registro: @fecha_hora_huso_gen_registro,
        num_registro_acuerdo_facturacion: @num_registro_acuerdo_facturacion,
        id_acuerdo_sistema_informatico: @id_acuerdo_sistema_informatico,
        tipo_huella: @tipo_huella,
        huella: @huella,
        signature: @signature
      )

    end
  end
end
