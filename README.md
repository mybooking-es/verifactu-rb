# Verifactu::Rb

Gema para generar el registro de factura de verifactu, la representación en XML y para realizar el envío.

## Uso


```ruby

  # Genera la huella inicial
  huella = Verifactu::Helper::GenerarHuellaRegistroAlta.execute(
														id_emisor_factura: 'B12345674',
														num_serie_factura: 'NC202500051',
														fecha_expedicion_factura: '22-07-2025',
														tipo_factura: 'F1',
														cuota_total: '55.54',
														importe_total: '320.00',
														huella: nil,
														fecha_hora_huso_gen_registro: '2025-07-22T10:00:00+02:00'
													)	

  # Crea el registro de factura alta
  registro_alta = Verifactu::RegistroAltaBuilder.new
      .con_id_factura('B12345674', 'NC202500051', '22-07-2025')
      .con_nombre_razon_emisor('Mi empresa SL')
      .con_tipo_factura('F1')
      .con_descripcion_operacion('Factura Reserva 2.731')
      .agregar_destinatario_nif(nombre_razon: 'Brad Stark', nif: '55555555K')
      .agregar_detalle_desglose(impuesto: '01', clave_regimen: '01', calificacion_operacion: 'S1',
                                tipo_impositivo: '21', base_imponible_o_importe_no_sujeto: '264.46',
                                cuota_repercutida: '55.54')
      .con_cuota_total('55.54')
      .con_importe_total('320.00')
      .con_encadenamiento_primer_registro
      .con_sistema_informatico(nombre_razon: 'Mi empresa SL', nif: 'B12345674',
                               nombre_sistema_informatico: 'Mi sistema', id_sistema_informatico: 'MB',
                               version: '1.0.0', numero_instalacion: 'Instalación 1',
                               tipo_uso_posible_solo_verifactu: 'S', tipo_uso_posible_multi_ot: 'S',
                               indicador_multi_ot: 'S')
      .con_fecha_hora_huso_gen_registro('2025-07-22T10:00:00+02:00')
      .con_tipo_huella('01')
      .con_huella(huella)
      .build
  
	# Genera el XML del registro de alta
	registro_alta_xml = Verifactu::RegistroAltaXmlBuilder.build(registro_alta)
	
	# Genera la cabecera
	cabecera = Verifactu::Cabecera.new(
							obligado_emision: Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(
								nombre_razon: 'Mi empresa SL',
								nif: 'B12345674'
							),
							representante: Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(
								nombre_razon: 'Representante SL',
								nif: 'B98765432'
							)
						)
  
	# Compone el mensaje para el envío
	xml_remision = Verifactu::RegFactuSistemaFacturacionXmlBuilder.build(cabecera, registro_alta_xml)
  xml = xml_remision.root.to_xml

  # Valida el esquema
  validate_schema = Verifactu::Helpers::ValidaSuministroXSD.execute(xml)

  # Envía a verifactu
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
