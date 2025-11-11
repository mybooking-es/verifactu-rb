module VerifactuHelpers

  def cabecera_sin_representante
    Verifactu::Cabecera.new(
      obligado_emision: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
        business_name: 'Mi empresa SL',
        nif: 'B12345674'
      )
    )
  end

  def cabecera_con_representante
    Verifactu::Cabecera.new(
      obligado_emision: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
        business_name: 'Mi empresa SL',
        nif: 'B12345674'
      ),
      representante: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
        business_name: 'Representante SL',
        nif: 'B98765432'
      )
    )
  end

  def huella_inicial
    Verifactu::Helper::GenerarHuellaRegistroAlta.execute(
      issuer_id: 'B12345674',
      series_number: 'NC202500051',
      issue_date: '22-07-2025',
      invoice_type: 'F1',
      total_tax: '55.54',
      total_amount: '320.00',
      fingerprint: nil,
      record_generation_datetime: '2025-07-22T10:00:00+02:00'
    )
  end

  def registro_alta_factura_valido(huella = huella_valida)
    Verifactu::HighRecordBuilder.new
      .with_invoice_id(issuer_id: 'B12345674',
                      series_number: 'NC202500051',
                      issue_date: '22-07-2025')
      .with_issuer_name('Mi empresa SL')
      .with_invoice_type('F1')
      .with_operation_description('Factura Reserva 2.731 - 22/07/2025 10:00 - 22/10/2025 10:00 - AAA-0009')
      .add_recipient_nif(business_name: 'Brad Stark', nif: '55555555K')
      .add_breakdown_detail(tax: '01', regime_key: '01', operation_qualification: 'S1',
                                tax_rate: '21', taxable_base_or_non_subject_amount: '264.46',
                                charged_tax: '55.54')
      .with_total_tax('55.54')
      .with_total_amount('320.00')
      .with_first_record_chaining
      .with_information_system(business_name: 'Mi empresa SL', nif: 'B12345674',
                               system_name: 'Mi sistema', system_id: 'MB',
                               version: '1.0.0', installation_number: 'Installation 1',
                               usage_type_verifactu_only: 'S', usage_type_multi_ot: 'S',
                               multiple_ot_indicator: 'S')
      .with_record_generation_datetime_timezone('2025-07-22T10:00:00+02:00')
      .with_fingerprint_type('01')
      .with_fingerprint(huella)
      .build
  end

  def filtro_consulta_simple_valida
    Verifactu::FiltroConsultaBuilder.new
    .with_imputation_period("2025", "02")
    .build
  end

  def filtro_consulta_compleja_valida
    Verifactu::FiltroConsultaBuilder.new
    .with_imputation_period("2025", "02")
    .with_series_number("A12")
    .with_counterparty_nif('Brad Stark', '55555555K')
    .with_specific_issue_date('20-02-2025')
    .with_external_ref('Mybooking-doralauto-menorca')
    .build
  end

  def cabecera_consulta_valida
    Verifactu::ConsultaFactu::CabeceraConsulta.cabecera_obligado_emisor(
      obligado_emision: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
        business_name: 'Mi empresa SL',
        nif: 'B12345674'
      ))
  end
end
