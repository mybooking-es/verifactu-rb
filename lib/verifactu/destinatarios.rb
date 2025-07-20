module Verifactu
  # Representa <sum1:Destinatarios>
  class Destinatarios
    attr_reader :id_destinatario

    def initialize(id_destinatario:)
      @id_destinatario = id_destinatario # Instancia de IDDestinatario
    end
  end
end
