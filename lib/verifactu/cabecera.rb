module Verifactu
  # Represents <sum1:Cabecera>
  class Cabecera
    attr_reader :id_version, :obligado_emision, :representante, :remision_requerimiento, :remision_voluntaria

    def initialize(obligado_emision:, representante: nil, remision_requerimiento: nil, remision_voluntaria: nil )

      # Validate obligado_emision
      raise Verifactu::VerifactuError, "obligado_emision is required" if obligado_emision.nil?
      unless obligado_emision.is_a?(InvoiceRegistration::LegalEntity)
        raise Verifactu::VerifactuError, "obligado_emision must be an instance of PersonaFisicaJuridica"
      end
      if obligado_emision.nif.nil? || obligado_emision.nif.empty?
        raise Verifactu::VerifactuError, "obligado_emision must have a NIF"
      end

      # Validate representante
      if representante
        unless representante.is_a?(InvoiceRegistration::LegalEntity)
          raise Verifactu::VerifactuError, "representante must be an instance of PersonaFisicaJuridica"
        end
        raise Verifactu::VerifactuError, "representante must have a NIF" if representante.nif.nil? || representante.nif.empty?
      end

      # Validate remision_requerimiento
      if remision_requerimiento
        unless remision_requerimiento.is_a?(InvoiceRegistration::RemisionRequerimiento)
          raise Verifactu::VerifactuError, "remision_requerimiento must be an instance of RemisionRequerimiento"
        end
      end

      # Validate remision_voluntaria
      if remision_voluntaria
        unless remision_voluntaria.is_a?(InvoiceRegistration::RemisionVoluntaria)
          raise Verifactu::VerifactuError, "remision_voluntaria must be an instance of RemisionVoluntaria"
        end
      end

      unless Verifactu::Config::L15.include?(Verifactu::Config::ID_VERSION)
        raise Verifactu::VerifactuError, "ID VERSION IS NOT AN ACCEPTED VERSION BY VERIFACTU"
      end

      @id_version = Verifactu::Config::ID_VERSION
      @obligado_emision = obligado_emision # Instance of PersonaFisicaJuridica
      @representante = representante # Instance of PersonaFisicaJuridica
      @remision_requerimiento = remision_requerimiento # Instance of RemisionRequerimiento
      @remision_voluntaria = remision_voluntaria # Instance of RemisionVoluntaria

    end
  end
end
