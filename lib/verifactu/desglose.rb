module Verifactu
  # Representa <sum1:Desglose>
  class Desglose
    attr_reader :detalles

    def initialize(detalles:)
      @detalles = detalles # Array de DetalleDesglose
    end
  end
end
