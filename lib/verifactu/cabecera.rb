module Verifactu
  # Representa <sum1:Cabecera>
  class Cabecera
    attr_reader :id_version, :obligado_emision, :representante, :tipo_registro_aeat

    def initialize(id_version:, obligado_emision:, representante: nil, tipo_registro_aeat:)
      raise ArgumentError, "id_version is required" if id_version.nil?
      raise ArgumentError, "obligado_emision is required" if obligado_emision.nil?
      raise ArgumentError, "tipo_registro_aeat is required" if tipo_registro_aeat.nil?
      raise ArgumentError, "obligado_emision must be an instance of ObligadoEmision" unless obligado_emision.is_a?(ObligadoEmision)
      raise ArgumentError, "representante must be an instance of Representante or nil" unless representante.nil? || representante.is_a?(Representante)
      @id_version = id_version
      @obligado_emision = obligado_emision # Instancia de ObligadoEmision
      @representante = representante # Instancia de Representante
      @tipo_registro_aeat = tipo_registro_aeat
    end
  end
end
