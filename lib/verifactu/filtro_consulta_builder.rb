module Verifactu
  #
  # It is a builder for creating instances of ConsultaFactu.
  #
  # @example
  #
  # Create a FiltroConsulta instance
  #
  #  filtro_consulta = Verifactu::FiltroConsultaBuilder.new
  #                    .con_periodo_imputacion("2025", "08")
  #                    .build
  #
  # Build the XML representation of the FiltroConsulta
  #
  #  xml = Verifactu::FiltroConsultaXmlBuilder.build(filtro_consulta)
  #
  class FiltroConsultaBuilder

    def initialize

    end

    def con_periodo_imputacion(ejercicio, periodo)
      @periodo_imputacion = Verifactu::ConsultaFactu::PeriodoImputacion.new(ejercicio: ejercicio, periodo: periodo)
      self
    end

    def con_num_serie_factura(num_serie_factura)
      @num_serie_factura = num_serie_factura
      self
    end

    def con_contraparte_nif(nombre_razon, nif)
      @contraparte = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(nombre_razon: nombre_razon, nif: nif)
      self
    end

    def con_contraparte_id_otro(nombre_razon, codigo_pais, id_type, id)
      id_otro = Verifactu::RegistroFacturacion::IdOtro(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @contraparte = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_id_otro(nombre_razon: nombre_razon, id_otro: id_otro)
      self
    end

    def con_fecha_expedicion_concreta(fecha)
      @fecha_expedicion = Verifactu::ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_concreta(fecha)
      self
    end

    def con_fecha_expedicion_rango(desde, hasta)
      @fecha_expedicion = Verifactu::ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_rango(desde: desde, hasta: hasta)
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
      @clave_paginacion = Verifactu::ConsultaFactu::ClavePaginacion.new(id_emisor_factura: id_emisor_factura, num_serie_factura: num_serie_factura, fecha_expedicion_factura: fecha_expedicion_factura)
      self
    end

    def build()
      Verifactu::ConsultaFactu::FiltroConsulta.new(
        periodo_imputacion: @periodo_imputacion,
        num_serie_factura: @num_serie_factura,
        contraparte: @contraparte,
        fecha_expedicion_factura: @fecha_expedicion,
        sistema_informatico: @sistema_informatico,
        ref_externa: @ref_externa,
        clave_paginacion: @clave_paginacion
      )
    end
  end
end
