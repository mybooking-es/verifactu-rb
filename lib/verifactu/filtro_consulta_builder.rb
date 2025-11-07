module Verifactu
  #
  # It is a builder for creating instances of ConsultaFactu.
  #
  # @example
  #
  # Create a FiltroConsulta instance
  #
  #  filtro_consulta = Verifactu::FiltroConsultaBuilder.new
  #                    .with_imputation_period("2025", "08")
  #                    .build
  #
  # Build the XML representation of the FiltroConsulta
  #
  #  xml = Verifactu::FiltroConsultaXmlBuilder.build(filtro_consulta)
  #
  class FiltroConsultaBuilder

    def initialize

    end

    def with_imputation_period(ejercicio, periodo)
      @periodo_imputacion = Verifactu::ConsultaFactu::PeriodoImputacion.new(ejercicio: ejercicio, periodo: periodo)
      self
    end

    def with_series_number(series_number)
      @num_serie_factura = series_number
      self
    end

    def with_counterparty_nif(business_name, nif)
      @contraparte = Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(business_name: business_name, nif: nif)
      self
    end

    def with_counterparty_other_id(business_name, codigo_pais, id_type, id)
      id_otro = Verifactu::InvoiceRegistration::OtherId.new(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @contraparte = Verifactu::InvoiceRegistration::LegalEntity.create_from_id_otro(business_name: business_name, other_id: id_otro)
      self
    end

    def with_specific_issue_date(fecha)
      @fecha_expedicion = Verifactu::ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_concreta(fecha)
      self
    end

    def with_issue_date_range(desde, hasta)
      @fecha_expedicion = Verifactu::ConsultaFactu::FechaExpedicionFactura.fecha_expedicion_rango(desde: desde, hasta: hasta)
      self
    end

    def with_information_system(business_name:, nif:, system_name:, system_id:, version:, installation_number:,
                   usage_type_verifactu_only:, usage_type_multi_ot:, multiple_ot_indicator:)
      @information_system = Verifactu::InvoiceRegistration::InformationSystem.new(business_name: business_name, nif: nif, system_name: system_name, system_id: system_id, version: version, installation_number: installation_number,
                   usage_type_verifactu_only: usage_type_verifactu_only, usage_type_multi_ot: usage_type_multi_ot, multiple_ot_indicator: multiple_ot_indicator)
      self
    end

    def with_external_ref(ref_externa)
      @external_ref = ref_externa
      self
    end

    def with_pagination_key(id_emisor_factura, num_serie_factura, fecha_expedicion_factura)
      @clave_paginacion = Verifactu::ConsultaFactu::ClavePaginacion.new(issuer_id: id_emisor_factura, series_number: num_serie_factura, issue_date: fecha_expedicion_factura)
      self
    end

    def build()
      Verifactu::ConsultaFactu::FiltroConsulta.new(
        periodo_imputacion: @periodo_imputacion,
        series_number: @num_serie_factura,
        contraparte: @contraparte,
        issue_date: @fecha_expedicion,
        information_system: @information_system,
        external_ref: @external_ref,
        clave_paginacion: @clave_paginacion
      )
    end
  end
end
