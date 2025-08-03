module Verifactu
  # Representa <sum1:Cabecera>
  class Cabecera
    attr_reader :id_version, :obligado_emision, :representante, :remision_requerimiento, :remision_voluntaria

    def initialize(obligado_emision:, representante: nil, remision_requerimiento: nil, remision_voluntaria: nil )

      # Validacion obligado_emision
      raise ArgumentError, "obligado_emision is required" if obligado_emision.nil?
      unless obligado_emision.is_a?(RegistroFacturacion::PersonaFisicaJuridica)
        raise ArgumentError, "obligado_emision must be an instance of PersonaFisicaJuridica"
      end
      if obligado_emision.nif.nil? || obligado_emision.nif.empty?
        raise ArgumentError, "obligado_emision debe tener un NIF"
      end

      # Validacion representante
      if representante
        unless representante.is_a?(RegistroFacturacion::PersonaFisicaJuridica)
          raise ArgumentError, "representante must be an instance of PersonaFisicaJuridica"
        end
        raise ArgumentError, "representante debe tener un NIF" if representante.nif.nil? || representante.nif.empty?
      end

      # Validacion remision_requerimiento
      if remision_requerimiento
        unless remision_requerimiento.is_a?(RegistroFacturacion::RemisionRequerimiento)
          raise ArgumentError, "remision_requerimiento must be an instance of RemisionRequerimiento"
        end
      end

      # Validacion remision_voluntaria
      if remision_voluntaria
        unless remision_voluntaria.is_a?(RegistroFacturacion::RemisionVoluntaria)
          raise ArgumentError, "remision_voluntaria must be an instance of RemisionVoluntaria"
        end
      end

      unless Verifactu::Config::L15.include?(Verifactu::Config::ID_VERSION)
        raise ArgumentError, "ID VERSION NO ES UNA VERSION ACEPTADA POR VERIFACTU"
      end

      @id_version = Verifactu::Config::ID_VERSION
      @obligado_emision = obligado_emision # Instancia de PersonaFisicaJuridica
      @representante = representante # Instancia de PersonaFisicaJuridica
      @remision_requerimiento = remision_requerimiento # Instancia de RemisionRequerimiento
      @remision_voluntaria = remision_voluntaria # Instancia de RemisionVoluntaria

    end
  end
end
