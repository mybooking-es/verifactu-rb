module Verifactu
  # Representa <sum1:Cabecera>
  class Cabecera
    attr_reader :id_version, :obligado_emision, :representante, :remision_requerimiento, :remision_voluntaria

    def initialize(obligado_emision:, representante: nil, remision_requerimiento: nil, remision_voluntaria: nil )

      # Validacion obligado_emision
      raise Verifactu::VerifactuError, "obligado_emision is required" if obligado_emision.nil?
      unless obligado_emision.is_a?(RegistroFacturacion::PersonaFisicaJuridica)
        raise Verifactu::VerifactuError, "obligado_emision must be an instance of PersonaFisicaJuridica"
      end
      if obligado_emision.nif.nil? || obligado_emision.nif.empty?
        raise Verifactu::VerifactuError, "obligado_emision debe tener un NIF"
      end

      # Validacion representante
      if representante
        unless representante.is_a?(RegistroFacturacion::PersonaFisicaJuridica)
          raise Verifactu::VerifactuError, "representante must be an instance of PersonaFisicaJuridica"
        end
        raise Verifactu::VerifactuError, "representante debe tener un NIF" if representante.nif.nil? || representante.nif.empty?
      end

      # Validacion remision_requerimiento
      if remision_requerimiento
        unless remision_requerimiento.is_a?(RegistroFacturacion::RemisionRequerimiento)
          raise Verifactu::VerifactuError, "remision_requerimiento must be an instance of RemisionRequerimiento"
        end
      end

      # Validacion remision_voluntaria
      if remision_voluntaria
        unless remision_voluntaria.is_a?(RegistroFacturacion::RemisionVoluntaria)
          raise Verifactu::VerifactuError, "remision_voluntaria must be an instance of RemisionVoluntaria"
        end
      end

      unless Verifactu::Config::L15.include?(Verifactu::Config::ID_VERSION)
        raise Verifactu::VerifactuError, "ID VERSION NO ES UNA VERSION ACEPTADA POR VERIFACTU"
      end

      @id_version = Verifactu::Config::ID_VERSION
      @obligado_emision = obligado_emision # Instancia de PersonaFisicaJuridica
      @representante = representante # Instancia de PersonaFisicaJuridica
      @remision_requerimiento = remision_requerimiento # Instancia de RemisionRequerimiento
      @remision_voluntaria = remision_voluntaria # Instancia de RemisionVoluntaria

    end
  end
end
