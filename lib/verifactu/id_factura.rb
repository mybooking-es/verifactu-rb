module Verifactu
  # Representa <sum1:IDFactura>
  class IDFactura
    attr_reader :id_emisor_factura, :num_serie_factura_emisor, :fecha_expedicion_factura_emisor

    def initialize(id_emisor_factura:, num_serie_factura_emisor:, fecha_expedicion_factura_emisor:)
      @id_emisor_factura = id_emisor_factura # Instancia de IDEmisorFactura
      @num_serie_factura_emisor = num_serie_factura_emisor
      @fecha_expedicion_factura_emisor = fecha_expedicion_factura_emisor
    end
  end
end
