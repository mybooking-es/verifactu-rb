module Verifactu
  #
  # Representa el destinatario de la factura en el módulo Verifactu.
  #
  class Destinatario
    attr_reader :nombre_razon, :nif
    #
    # @param nombre_razon [String] The name or reason of the entity.
    # @param nif [String] The NIF (Número de Identificación Fiscal) of the entity.
    #
    def initialize(nombre_razon:, nif:)
      @nombre_razon = nombre_razon
      @nif = nif
    end
  end
end
