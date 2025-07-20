module Verifactu
  # Representa <sum1:IDDestinatario>
  class IDDestinatario
    attr_reader :nombre_razon, :nif

    def initialize(nombre_razon:, nif:)
      @nombre_razon = nombre_razon
      @nif = nif
    end
  end
end
