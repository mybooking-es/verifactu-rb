module Verifactu
  class Emisor
    attr_reader :nombre_razon, :nif
    #
    # Initializes a new instance of the Emisor class.
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
