module Verifactu
  class EncadenamientoRegistroAnterior
    attr_reader :nif, :num_serie_factura, :fecha_expedicion, :huella_registro_anterior

    #
    # @param nif [String] NIF del emisor de la factura anterior.
    # @param num_serie_factura [String] Número de factura anterior.
    # @param fecha_expedicion [String] Fecha de expedición de la factura anterior (YYYY-MM-DD).
    # @param huella_registro_anterior [String] Hash de la factura anterior.
    #
    def initialize(nif:, num_serie_factura:, fecha_expedicion:, huella_registro_anterior:)
      @nif = nif
      @num_serie_factura = num_serie_factura
      @fecha_expedicion = fecha_expedicion
      @huella_registro_anterior = huella_registro_anterior
    end
  end
end
