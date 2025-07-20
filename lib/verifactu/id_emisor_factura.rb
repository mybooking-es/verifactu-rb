module Verifactu
  # Representa <sum1:IDEmisorFactura>
  class IDEmisorFactura
    attr_reader :nif

    def initialize(nif:)
      @nif = nif
    end
  end
end
