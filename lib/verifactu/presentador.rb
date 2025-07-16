module Verifactu
  class Presentador
    attr_reader :nombre_razon, :nif
    def initialize(nombre_razon:, nif:)
      @nombre_razon = nombre_razon
      @nif = nif
    end
  end
end
