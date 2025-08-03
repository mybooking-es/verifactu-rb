require 'savon'
require 'nokogiri'

require_relative "verifactu/config/verifactu_config"
require_relative "verifactu/helpers/validador"
require_relative "verifactu/helpers/generar_huella_registro_alta"
require_relative "verifactu/helpers/valida_suministro_xsd"

require_relative "verifactu/registro_facturacion/registro_alta"
require_relative "verifactu/registro_facturacion/registro_anulacion"
require_relative "verifactu/registro_facturacion/detalle_desglose"
require_relative "verifactu/registro_facturacion/encadenamiento"
require_relative "verifactu/registro_facturacion/id_factura"
require_relative "verifactu/registro_facturacion/id_otro"
require_relative "verifactu/registro_facturacion/importe_rectificacion"
require_relative "verifactu/registro_facturacion/persona_fisica_juridica"
require_relative "verifactu/registro_facturacion/remision_requerimiento"
require_relative "verifactu/registro_facturacion/remision_voluntaria"
require_relative "verifactu/registro_facturacion/sistema_informatico"

require_relative "verifactu/cabecera"
require_relative "verifactu/registro_alta_builder"
require_relative "verifactu/registro_alta_xml_builder"
require_relative "verifactu/reg_factu_sistema_facturacion_xml_builder"
require_relative "verifactu/envio_verifactu_service"

require_relative "verifactu/version"
