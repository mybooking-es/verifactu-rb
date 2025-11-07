# Verifactu::Rb

Ruby gem for generating Verifactu invoice records, XML representation, and submission.

## Usage

```ruby

  # Generate the initial fingerprint
  huella = Verifactu::Helper::GenerarHuellaRegistroAlta.execute(
              issuer_id: 'B12345674',
              series_number: 'NC202500051',
              issue_date: '22-07-2025',
              invoice_type: 'F1',
              total_tax: '55.54',
              total_amount: '320.00',
              fingerprint: nil,
              record_generation_datetime: '2025-07-22T10:00:00+02:00'
            )

  # Create the high invoice record
  high_record = Verifactu::HighRecordBuilder.new
      .with_invoice_id(issuer_id: 'B12345674',
                       series_number: 'NC202500051',
                       issue_date: '22-07-2025')
      .with_issuer_name('My Company SL')
      .with_invoice_type('F1')
      .with_operation_description('Invoice Reservation 2.731')
      .add_recipient_nif(business_name: 'Brad Stark', nif: '55555555K')
      .add_breakdown_detail(tax: '01', regime_key: '01', operation_qualification: 'S1',
                            tax_rate: '21', taxable_base_or_non_subject_amount: '264.46',
                            charged_tax: '55.54')
      .with_total_tax('55.54')
      .with_total_amount('320.00')
      .with_first_record_chaining
      .with_information_system(business_name: 'My Company SL', nif: 'B12345674',
                               system_name: 'My System', system_id: 'MB',
                               version: '1.0.0', installation_number: 'Installation 1',
                               usage_type_verifactu_only: 'S', usage_type_multi_ot: 'S',
                               multiple_ot_indicator: 'S')
      .with_record_generation_datetime_timezone('2025-07-22T10:00:00+02:00')
      .with_fingerprint_type('01')
      .with_fingerprint(huella)
      .build

  # Generate the XML for the high record
  high_record_xml = Verifactu::HighRecordXmlBuilder.build(high_record)

  # Generate the header
  cabecera = Verifactu::Cabecera.new(
              obligado_emision: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
                business_name: 'My Company SL',
                nif: 'B12345674'
              ),
              representante: Verifactu::InvoiceRegistration::LegalEntity.create_from_nif(
                business_name: 'Representative SL',
                nif: 'B98765432'
              )
            )

  # Compose the message for submission
  xml_remision = Verifactu::RegFactuSistemaFacturacionXmlBuilder.build(cabecera, high_record_xml)
  xml = xml_remision.root.to_xml

  # Validate the schema
  validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml)

  # Send to Verifactu
  if validate_schema[:valid]
    service = Verifactu::EnvioVerifactuService.new
    result = service.send_verifactu(environment: :pre_prod,
                          reg_factu_xml: xml,
                          client_cert: cert,
                          client_key: key)
  end


```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
