module Verifactu
  #
  # It is a builder for creating instances of ConsultaFactu.
  #
  # @example
  #
  # Create a RegistroAlta instance with the required fields
  #
  #  registro_alta = Verifactu::RegistroAltaBuilder.new
  #    .con_id_factura(id_emisor_factura: 'B12345674',
  #                    num_serie_factura: 'NC202500051',
  #                    fecha_expedicion_factura: '22-07-2025')
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
  #                             indicador_multiples_ot: 'S')
  #    .con_fecha_hora_huso_gen_registro('2025-07-22T10:00:00+02:00')
  #    .con_tipo_huella('01')
  #    .con_huella(huella)
  #    .build
  #
  # Build the XML representation of the RegistroAlta
  #
  #  xml = Verifactu::RegistroAltaXmlBuilder.build(registro_alta)
  #
  class FiltroConsultaBuilder

    def initialize

    end

    def con_periodo_imputacion(ejercicio, periodo)
      @ejercicio = ejercicio
      @periodo = periodo
      self
    end

    def con_num_serie_factura(num_serie_factura)
      @num_serie_factura = num_serie_factura
      self
    end

    def con_contraparte_nif(nombre_razon, nif)
      @contraparte = new RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(nombre_razon: nombre_razon, nif: nif)
      self
    end

    def con_contraparte_id_otro(nombre_razon, codigo_pais, id_type, id)
      id_otro = new RegistroFacturacion::IdOtro(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @contraparte = new RegistroFacturacion::PersonaFisicaJuridica.create_from_id_otro(nombre_razon: nombre_razon, id_otro: id_otro)
      self
    end

    def con_fecha_expedicion_concreta(fecha)
      @fecha_expedicion_concreta = new ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_concreta(fecha_expedicion: fecha)
      self
    end

    def con_fecha_expedicion_rango(desde, hasta)
      @fecha_expedicion_rango = new ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_rango(desde: desde, hasta: hasta)
      self
    end

    def con_sistema_informatico(nombre_razon:, nif:, nombre_sistema_informatico:, id_sistema_informatico:, version:, numero_instalacion:,
                   tipo_uso_posible_solo_verifactu:, tipo_uso_posible_multi_ot:, indicador_multiples_ot:)
      @sistema_informatico = Verifactu::RegistroFacturacion::SistemaInformatico.new(nombre_razon: nombre_razon, nif: nif, nombre_sistema_informatico: nombre_sistema_informatico, id_sistema_informatico: id_sistema_informatico, version: version, numero_instalacion: numero_instalacion,
                   tipo_uso_posible_solo_verifactu: tipo_uso_posible_solo_verifactu, tipo_uso_posible_multi_ot: tipo_uso_posible_multi_ot, indicador_multiples_ot: indicador_multiples_ot)
      self
    end

    def con_ref_externa(ref_externa)
      @ref_externa = ref_externa
      self
    end

    def con_clave_paginacion(id_emisor_factura, num_serie_factura, fecha_expedicion_factura)
      @clave_paginacion = ConsultaFactu::ClavePaginacion.new(id_emisor_factura: id_emisor_factura, num_serie_factura: num_serie_factura, fecha_expedicion_factura: fecha_expedicion_factura)
      self
    end

    def build()
      ConsultaFactu::FiltroConsulta.new(
        periodo_imputacion: @periodo_imputacion,
        num_serie_factura: @num_serie_factura,
        contraparte: @contraparte,
        fecha_expedicion_concreta: @fecha_expedicion_concreta,
        fecha_expedicion_rango: @fecha_expedicion_rango,
        sistema_informatico: @sistema_informatico,
        ref_externa: @ref_externa,
        clave_paginacion: @clave_paginacion
      )
    end
  end
end
