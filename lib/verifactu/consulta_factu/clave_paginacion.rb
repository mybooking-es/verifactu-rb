module Verifactu
  module ConsultaFactu
    class ClavePaginacion
      attr_reader :id_emisor_factura, :num_serie_factura, :fecha_expedicion_factura

      def initialize(id_emisor_factura, num_serie_factura, fecha_expedicion_factura)

        raise Verifactu::VerifactuError, "id_emisor_factura is required" if id_emisor_factura.nil?
        raise Verifactu::VerifactuError, "num_serie_factura is required" if num_serie_factura.nil?
        raise Verifactu::VerifactuError, "fecha_expedicion_factura is required" if fecha_expedicion_factura.nil?

        Verifactu::Helper::Validador.validar_nif(id_emisor_factura)
        raise Verifactu::VerifactuError, "fecha_expedicion_factura must be a valid date" unless Verifactu::Helpers.fecha_valida?(fecha_expedicion_factura)

        @id_emisor_factura = id_emisor_factura
        @num_serie_factura = num_serie_factura
        @fecha_expedicion_factura = fecha_expedicion_factura
      end

    end
  end
end