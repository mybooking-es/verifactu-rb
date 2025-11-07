require 'savon'
require 'nokogiri'
require 'rqrcode'
require 'erb'
require_relative "verifactu/verifactu_error"
require_relative "verifactu/config/verifactu_config"
require_relative "verifactu/helpers/validador"
require_relative "verifactu/helpers/generar_huella_registro_alta"
require_relative "verifactu/helpers/xsd_loader"
require_relative "verifactu/helpers/valida_suministro_xsd"
require_relative "verifactu/helpers/valida_consulta_xsd"

require_relative "verifactu/invoice_registration/high_record"
require_relative "verifactu/invoice_registration/cancellation_record"
require_relative "verifactu/invoice_registration/breakdown_detail"
require_relative "verifactu/invoice_registration/chaining"
require_relative "verifactu/invoice_registration/invoice_id"
require_relative "verifactu/invoice_registration/other_id"
require_relative "verifactu/invoice_registration/rectification_amount"
require_relative "verifactu/invoice_registration/legal_entity"
require_relative "verifactu/invoice_registration/requirement_remission"
require_relative "verifactu/invoice_registration/voluntary_remission"
require_relative "verifactu/invoice_registration/information_system"

require_relative "verifactu/consulta_factu/clave_paginacion"
require_relative "verifactu/consulta_factu/consulta_factu"
require_relative "verifactu/consulta_factu/fecha_expedicion_factura"
require_relative "verifactu/consulta_factu/filtro_consulta"
require_relative "verifactu/consulta_factu/periodo_imputacion"
require_relative "verifactu/consulta_factu/cabecera_consulta"

require_relative "verifactu/cabecera"
require_relative "verifactu/consulta_factu_xml_builder"
require_relative "verifactu/high_record_builder"
require_relative "verifactu/high_record_xml_builder"
require_relative "verifactu/reg_factu_sistema_facturacion_xml_builder"
require_relative "verifactu/envio_verifactu_service_base"
require_relative "verifactu/envio_verifactu_service"
require_relative "verifactu/envio_verifactu_service_consulta"
require_relative "verifactu/genera_qr_service"
require_relative "verifactu/filtro_consulta_builder"
require_relative "verifactu/filtro_consulta_xml_builder"
require_relative "verifactu/consulta_factu_xml_builder"



require_relative "verifactu/version"
