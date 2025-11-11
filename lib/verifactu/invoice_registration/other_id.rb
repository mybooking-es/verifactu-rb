module Verifactu
  module InvoiceRegistration
    # Represents <sum1:IDDestinatario>
    class OtherId
      attr_reader :codigo_pais, :id_type, :id

      def initialize(codigo_pais: nil, id_type:, id:)
        raise Verifactu::VerifactuError, "id_type is required" if id_type.nil?
        raise Verifactu::VerifactuError, "id is required" if id.nil?

        raise Verifactu::VerifactuError, "id_type must be a string" unless Verifactu::Helper::Validador.cadena_valida?(id_type)
        raise Verifactu::VerifactuError, "id_type must be within #{Verifactu::Config::L7.join(', ')}" unless Verifactu::Config::L7.include?(id_type)
        raise Verifactu::VerifactuError, "id must be a string" unless Verifactu::Helper::Validador.cadena_valida?(id)

        if id_type == '02' # If IDType == "02" (NIF-IVA), CodigoPais field will not be required.
          #TODO When identified through the IDOtro group and IDType is "02", it will be
          # validated that the ID identifier field conforms to the NIF-IVA structure of one of the
          # Member States and must be identified.
        else
          raise Verifactu::VerifactuError, "codigo_pais is required" if codigo_pais.nil?
          raise Verifactu::VerifactuError, "codigo_pais must be a string" unless Verifactu::Helper::Validador.cadena_valida?(codigo_pais)
          raise Verifactu::VerifactuError, "codigo_pais must be within #{Verifactu::Config::PAISES_PERMITIDOS.join(', ')}" unless Verifactu::Config::PAISES_PERMITIDOS.include?(codigo_pais)
          if codigo_pais == 'ES'
            raise Verifactu::VerifactuError, "id_type must be Spanish passport (03) or not registered (07)" unless id_type == '03' || id_type == '07'
          end
        end


        # Additional validations according to ID type
        #TODO implement ID validation (https://www.agenciatributaria.es/static_files/AEAT_Desarrolladores/EEDD/IVA/VERI-FACTU/Validaciones_Errores_Veri-Factu.pdf)

        @codigo_pais = codigo_pais.upcase
        @id_type = id_type
        @id = id
      end
    end
  end
end
