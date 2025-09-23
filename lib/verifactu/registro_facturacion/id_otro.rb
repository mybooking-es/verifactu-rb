module Verifactu
  module RegistroFacturacion
    # Representa <sum1:IDDestinatario>
    class IDOtro
      attr_reader :codigo_pais, :id_type, :id

      def initialize(codigo_pais: nil, id_type:, id:)
        raise Verifactu::VerifactuError, "id_type is required" if id_type.nil?
        raise Verifactu::VerifactuError, "id is required" if id.nil?

        raise Verifactu::VerifactuError, "id_type must be a string" unless Verifactu::Helper::Validador.cadena_valida?(id_type)
        raise Verifactu::VerifactuError, "id_type debe estar dentro de #{Verifactu::Config::L7.join(', ')}" unless Verifactu::Config::L7.include?(id_type)
        raise Verifactu::VerifactuError, "id must be a string" unless Verifactu::Helper::Validador.cadena_valida?(id)

        if id_type == '02' #Si el campo IDType == “02” (NIF-IVA), no será exigible el campo CodigoPais.
          #TODO Cuando se identifique a través de la agrupación IDOtro e IDType sea “02”, se
          # validará que el campo identificador ID se ajuste a la estructura de NIF-IVA de alguno de los
          # Estados Miembros y debe estar identificado.
        else
          raise Verifactu::VerifactuError, "codigo_pais is required" if codigo_pais.nil?
          raise Verifactu::VerifactuError, "codigo_pais must be a string" unless Verifactu::Helper::Validador.cadena_valida?(codigo_pais)
          raise Verifactu::VerifactuError, "codigo_pais debe estar dentro de #{Verifactu::Config::PAISES_PERMITIDOS.join(', ')}" unless Verifactu::Config::PAISES_PERMITIDOS.include?(codigo_pais)
          if codigo_pais == 'ES'
            raise Verifactu::VerifactuError, "id_type debe ser pasaporte español (03) o no censado (07)" unless id_type == '03' || id_type == '07'
          end
        end


        # Validaciones adicionales según el tipo de ID
        #TODO implementar validación de ID (https://www.agenciatributaria.es/static_files/AEAT_Desarrolladores/EEDD/IVA/VERI-FACTU/Validaciones_Errores_Veri-Factu.pdf)

        @codigo_pais = codigo_pais.upcase
        @id_type = id_type
        @id = id
      end
    end
  end
end
