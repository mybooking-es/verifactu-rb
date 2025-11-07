module Verifactu
  module RegistroFacturacion
    #
    # It represents the SIF (Sistema de Información Fiscal) class in the Verifactu module.
    #
    class SistemaInformatico
      attr_reader :nombre_razon, :nif, :id_otro, :nombre_sistema_informatico,
                  :id_sistema_informatico, :version, :numero_instalacion,
                  :tipo_uso_posible_solo_verifactu, :tipo_uso_posible_multi_ot, :indicador_multiples_ot

      # Initializes a new instance of the Sif class.
      #
      # @param nombre_razon [String] The name or reason of the entity.
      # @param nif [String] The NIF (Número de Identificación Fiscal) of the entity.
      # @param nombre_sistema_informatico [String] The name of the information system.
      # @param id_sistema_informatico [String] The ID of the information system.
      # @param version [String] The version of the information system.
      # @param numero_instalacion [String] The installation number of the information system.
      # @param tipo_uso_posible_solo_verifactu [String] The possible use type for Verifactu only.
      # @param tipoUsoPosibleOtros [String] The possible use type for other systems.
      # @param tipoUsoPosibleMultiOT [String] The possible use type for multiple systems.
      #
      def initialize(nombre_razon:, nif: nil, id_otro: nil, nombre_sistema_informatico: nil, id_sistema_informatico:,
                    version:, numero_instalacion:,
                    tipo_uso_posible_solo_verifactu:, tipo_uso_posible_multi_ot:, indicador_multiples_ot:)
        raise Verifactu::VerifactuError, "nombre_razon is required" if nombre_razon.nil? || nombre_razon.empty?
        raise Verifactu::VerifactuError, "nif o id_otro is required" if nif.nil? && id_otro.nil?
        raise Verifactu::VerifactuError, "only nif or id_otro can be defined, not both" if nif && id_otro
        raise Verifactu::VerifactuError, "id_sistema_informatico is required" if id_sistema_informatico.nil?
        raise Verifactu::VerifactuError, "version is required" if version.nil? || version.empty?
        raise Verifactu::VerifactuError, "numero_instalacion is required" if numero_instalacion.nil?

        # In one place it says required and in another optional, left as required
        raise Verifactu::VerifactuError, "tipo_uso_posible_solo_verifactu is required" if tipo_uso_posible_solo_verifactu.nil?
        raise Verifactu::VerifactuError, "tipo_uso_posible_multi_ot is required" if tipo_uso_posible_multi_ot.nil?
        raise Verifactu::VerifactuError, "indicador_multiples_ot is required" if indicador_multiples_ot.nil?

        raise Verifactu::VerifactuError, "nombre_razon must be a String" unless Verifactu::Helper::Validador.cadena_valida?(nombre_razon)
        raise Verifactu::VerifactuError, "nombre_razon must have a maximum of 120 caracteres" if nombre_razon.length > 120

        if nif
          Verifactu::Helper::Validador.validar_nif(nif)
        elsif id_otro
          raise Verifactu::VerifactuError, "id_otro must be an instance of IDOtro" unless id_otro.is_a?(IDOtro)
          raise Verifactu::VerifactuError, "the information system owner must be registered" if id_otro.id_type == "07"
        end

        if nombre_sistema_informatico
          raise Verifactu::VerifactuError, "nombre_sistema_informatico must be a String" unless Verifactu::Helper::Validador.cadena_valida?(nombre_sistema_informatico)
          raise Verifactu::VerifactuError, "nombre_sistema_informatico must have a maximum of 20 caracteres" if nombre_sistema_informatico.length > 20
        end

        raise Verifactu::VerifactuError, "id_sistema_informatico must be a String" unless Verifactu::Helper::Validador.cadena_valida?(id_sistema_informatico)
        raise Verifactu::VerifactuError, "id_sistema_informatico must have 2 characters" unless id_sistema_informatico.length == 2

        raise Verifactu::VerifactuError, "version must be a String" unless Verifactu::Helper::Validador.cadena_valida?(version)
        raise Verifactu::VerifactuError, "version must have a maximum of 50 caracteres" if version.length > 50

        raise Verifactu::VerifactuError, "numero_instalacion must be a String" unless Verifactu::Helper::Validador.cadena_valida?(numero_instalacion)
        raise Verifactu::VerifactuError, "numero_instalacion must have a maximum of 100 caracteres" if numero_instalacion.length > 100

        if tipo_uso_posible_solo_verifactu
          raise Verifactu::VerifactuError, "tipo_uso_posible_solo_verifactu must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(tipo_uso_posible_solo_verifactu.upcase)
        end

        if tipo_uso_posible_multi_ot
          raise Verifactu::VerifactuError, "tipo_uso_posible_multi_ot must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(tipo_uso_posible_multi_ot.upcase)
        end

        if indicador_multiples_ot
          raise Verifactu::VerifactuError, "indicador_multiples_ot must be in #{Verifactu::Config::L14.join(', ')}" unless Verifactu::Config::L14.include?(indicador_multiples_ot.upcase)
        end

        @nombre_razon = nombre_razon
        @nif = nif
        @nombre_sistema_informatico = nombre_sistema_informatico
        @id_sistema_informatico = id_sistema_informatico.upcase
        @version = version
        @numero_instalacion = numero_instalacion
        @tipo_uso_posible_solo_verifactu = tipo_uso_posible_solo_verifactu.upcase
        @tipo_uso_posible_multi_ot = tipo_uso_posible_multi_ot.upcase
        @indicador_multiples_ot = indicador_multiples_ot.upcase
      end
    end
  end
end
