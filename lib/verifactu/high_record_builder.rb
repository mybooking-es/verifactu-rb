module Verifactu
  #
  # It is a builder for creating instances of RegistroAlta.
  #
  # @example
  #
  # Create a RegistroAlta instance with the required fields
  #
  #  registro_alta = Verifactu::HighRecordBuilder.new
  #    .with_invoice_id(issuer_id: 'B12345674',
  #                    series_number: 'NC202500051',
  #                    issue_date: '22-07-2025')
  #    .with_issuer_name('Mi empresa SL')
  #    .with_invoice_type('F1')
  #    .with_operation_description('Factura Reserva 2.731 - 22/07/2025 10:00 - 22/10/2025 10:00 - AAA-0009')
  #    .add_recipient_nif(business_name: 'Brad Stark', nif: '55555555K')
  #    .add_breakdown_detail(impuesto: '01', clave_regimen: '01', calificacion_operacion: 'S1',
  #                              cuota_repercutida: '55.54')
  #    .with_total_tax('55.54')
  #                              tipo_impositivo: '21', base_imponible_o_importe_no_sujeto: '264.46',
  #    .with_total_amount('320.00')
  #    .with_first_record_chaining
  #    .with_information_system(business_name: 'Mi empresa SL', nif: 'B12345674',
  #                             system_name: 'Mi sistema', system_id: 'MB',
  #                             version: '1.0.0', installation_number: 'Instalación 1',
  #                             usage_type_verifactu_only: 'S', usage_type_multi_ot: 'S',
  #                             multiple_ot_indicator: 'S')
  #    .with_record_generation_datetime_timezone('2025-07-22T10:00:00+02:00')
  #    .with_fingerprint_type('01')
  #    .with_fingerprint(huella)
  #    .build
  #
  # Build the XML representation of the RegistroAlta
  #
  #  xml = Verifactu::RegistroAltaXmlBuilder.build(registro_alta)
  #
  class HighRecordBuilder

    def initialize
      @recipients = []
      @breakdown = []
      @rectified_invoices = []
      @replaced_invoices = []
      @rectification = 'N'
      @previous_rejection = 'N'
      @operation_description = Verifactu::Config::DESCRIPCION_OPERACION_DEFECTO
      @macro_data = 'N'
      @coupon = 'N'
      @issued_by_third_party_or_recipient = 'D'
    end

    #
    # Set the IDFactura for the invoice. (required)
    #
    def with_invoice_id(issuer_id:, series_number:, issue_date:)
      @invoice_id = Verifactu::InvoiceRegistration::InvoiceId.new(issuer_id: issuer_id,
                                             series_number: series_number,
                                             issue_date: issue_date)
      self
    end

    #
    # Set the external reference for the invoice. (optional)
    #
    def with_external_ref(ref_externa)
      @external_ref = ref_externa
      self
    end

    #
    # Set the name or the issuer. (required)
    #
    def with_issuer_name(nombre_razon)
      @issuer_name = nombre_razon
      self
    end

    def with_rectification(subsanacion = 'S')
      @rectification = subsanacion
      self
    end

    def with_previous_rejection(rechazo_previo = 'S')
      @previous_rejection = rechazo_previo
      self
    end

    #
    # Set the invoice type. (required)
    # @param tipo_factura [String] The type of the invoice, e.g., 'F1' for ordinary invoice.
    #
    def with_invoice_type(tipo_factura)
      @invoice_type = tipo_factura
      self
    end

    def with_rectification_type(tipo_rectificativa)
      @rectification_type = tipo_rectificativa
      self
    end

    def add_rectified_invoice(id_emisor, num_serie, fecha_expedicion)
      @rectified_invoices << Verifactu::InvoiceRegistration::InvoiceId.new(issuer_id: id_emisor, series_number: num_serie, issue_date: fecha_expedicion)
      self
    end

    def add_replaced_invoice(id_emisor, num_serie, fecha_expedicion)
      @replaced_invoices << Verifactu::InvoiceRegistration::InvoiceId.new(issuer_id: id_emisor, series_number: num_serie, issue_date: fecha_expedicion)
      self
    end

    def with_rectification_amount(base_rectificada, cuota_rectificada, cuota_recargo_rectificada = nil)
      @rectification_amount = Verifactu::InvoiceRegistration::RectificationAmount.new(base_rectificada: base_rectificada, cuota_rectificada: cuota_rectificada, cuota_recargo_rectificada: cuota_recargo_rectificada)
      self
    end

    def with_operation_date(fecha_operacion)
      @operation_date = fecha_operacion
      self
    end

    def with_operation_description(descripcion_operacion)
      @operation_description = descripcion_operacion
      self
    end

    def simplified_invoice_art7273(valor = 'S')
      @simplified_invoice_art7273 = valor
      self
    end

    def invoice_without_recipient_identification_art61d(valor = 'S')
      @factura_sin_identificar_destinatario_Art61d = valor
      self
    end

    def with_macro_data(macrodato = 'S')
      @macro_data = macrodato
      self
    end

    def issued_by_third_party_or_recipient(valor = 'D')
      @issued_by_third_party_or_recipient = valor
      self
    end

    def with_third_party_nif(business_name, identificacion)
      @third_party = Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(business_name: business_name, nif: identificacion)
      self
    end

    def with_third_party_other_id(business_name, codigo_pais, id_type, id)
      @other_id = Verifactu::InvoiceRegistration::OtherId.new(codigo_pais: codigo_pais, id_type: id_type, id: id)
      @third_party = Verifactu::InvoiceRegistration::LegalEntity.create_from_id_otro(business_name: business_name, other_id: @other_id)
      self
    end

      def add_recipient_nif(business_name:, nif:)
        @recipients << Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(business_name: business_name, nif: nif)
        self
      end

    def add_recipient_other_id(business_name:, country_code:, id_type:, id:)
      id_otro = Verifactu::InvoiceRegistration::OtherId.new(codigo_pais: country_code, id_type: id_type, id: id)
      @recipients << Verifactu::InvoiceRegistration::LegalEntity.create_from_id_otro(business_name: business_name, other_id: id_otro)
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
    def add_breakdown_detail(tax:, regime_key:, operation_qualification:, tax_rate:,
                                 taxable_base_or_non_subject_amount:, charged_tax:,
                                 equivalence_surcharge_type: nil, equivalence_surcharge_amount: nil)

      desglose_item = Verifactu::InvoiceRegistration::BreakdownDetail.create_operacion(
                                                impuesto: tax,
                                                clave_regimen: regime_key,
                                                calificacion_operacion: operation_qualification,
                                                tipo_impositivo: tax_rate,
                                                base_imponible_o_importe_no_sujeto: taxable_base_or_non_subject_amount,
                                                cuota_repercutida: charged_tax,
                                                tipo_recargo_equivalencia: equivalence_surcharge_type,
                                                cuota_recargo_equivalencia: equivalence_surcharge_amount
                                             )

      @breakdown << desglose_item
      self

    end

    def has_coupon(valor = 'S')
      @coupon = valor
      self
    end

    def with_total_tax(cuota_total)
      @total_tax = cuota_total
      self
    end

    def with_total_amount(importe_total)
      @total_amount = importe_total
      self
    end

    def first_record(valor = 'S')
      @primer_registro = valor
      self
    end

    def with_first_record_chaining
      @chaining = Verifactu::InvoiceRegistration::Chaining.crea_encadenamiento_primer_registro
      self
    end

    def with_previous_record_chaining(id_emisor:, series_number:, issue_date:, huella_anterior:)
      @chaining = Verifactu::InvoiceRegistration::Chaining.crea_encadenamiento_registro_anterior(
        issuer_id: id_emisor,
        series_number: num_serie_factura,
        issue_date: fecha_expedicion_factura,
        fingerprint: huella_anterior
      )
      self
    end

    def with_information_system(business_name:, nif:, system_name:, system_id:, version:, installation_number:,
                   usage_type_verifactu_only:, usage_type_multi_ot:, multiple_ot_indicator:)
      @information_system = Verifactu::InvoiceRegistration::InformationSystem.new(business_name: business_name, nif: nif, system_name: system_name, system_id: system_id, version: version, installation_number: installation_number,
                   usage_type_verifactu_only: usage_type_verifactu_only, usage_type_multi_ot: usage_type_multi_ot, multiple_ot_indicator: multiple_ot_indicator)
      self
    end

    def with_record_generation_datetime_timezone(fecha_hora_huso_gen_registro)
      @record_generation_datetime = fecha_hora_huso_gen_registro
      self
    end

    def with_information_system_agreement_id(id_acuerdo_sistema_informatico)
      @information_system_agreement_id = id_acuerdo_sistema_informatico
      self
    end

    def with_fingerprint_type(tipo_huella)
      @fingerprint_type = tipo_huella
      self
    end

    def with_fingerprint(huella)
      @fingerprint = huella
      self
    end

    def with_signature(signature)
      @signature = signature
      self
    end

    def build
      Verifactu::InvoiceRegistration::HighRecord.new(
        invoice_id: @invoice_id,
        external_ref: @external_ref,
        issuer_name: @issuer_name,
        rectification: @rectification,
        previous_rejection: @previous_rejection,
        invoice_type: @invoice_type,
        rectification_type: @rectification_type,
        rectified_invoices: @rectified_invoices,
        replaced_invoices: @replaced_invoices,
        rectification_amount: @rectification_amount,
        operation_date: @operation_date,
        operation_description: @operation_description,
        simplified_invoice_art7273: @simplified_invoice_art7273,
        invoice_without_recipient_id_art61d: @invoice_without_recipient_id_art61d,
        macro_data: @macro_data,
        issued_by_third_party_or_recipient: @issued_by_third_party_or_recipient,
        third_party: @third_party,
        recipients: @recipients,
        coupon: @coupon,
        breakdown: @breakdown,
        total_tax: @total_tax,
        total_amount: @total_amount,
        chaining: @chaining,
        information_system: @information_system,
        record_generation_datetime: @record_generation_datetime,
        num_registro_acuerdo_facturacion: @num_registro_acuerdo_facturacion,
        information_system_agreement_id: @information_system_agreement_id,
        fingerprint_type: @fingerprint_type,
        fingerprint: @fingerprint,
        signature: @signature
      )

    end
  end
end
