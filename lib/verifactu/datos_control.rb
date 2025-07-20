module Verifactu
  # Representa <sum:DatosControl>
  class DatosControl
    attr_reader :huella, :tipo_hash

    def initialize(huella:, tipo_hash:)
      @huella = huella
      @tipo_hash = tipo_hash
    end
  end
end
