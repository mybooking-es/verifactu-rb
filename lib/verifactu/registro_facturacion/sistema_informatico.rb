module Verifactu
  module RegistroFacturacion
    #
    # It represents the SIF (Sistema de Información Fiscal) class in the Verifactu module.
    #
    class SistemaInformatico
      attr_reader :nombre_razon, :nif, :id_otro, :nombre_sistema_informatico,
                  :id_sistema_informatico, :version, :numero_instalacion,
                  :tipo_uso_posible_solo_verifactu, :tipo_uso_posible_multi_ot, :indicador_multi_ot

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
                    tipo_uso_posible_solo_verifactu:, tipo_uso_posible_multi_ot:, indicador_multi_ot:)
        raise ArgumentError, "nombre_razon is required" if nombre_razon.nil? || nombre_razon.empty?
        raise ArgumentError, "nif o id_otro is required" if nif.nil? && id_otro.nil?
        raise ArgumentError, "solo se puede definir nif o id_otro, no ambos" if nif && id_otro
        raise ArgumentError, "id_sistema_informatico is required" if id_sistema_informatico.nil?
        raise ArgumentError, "version is required" if version.nil? || version.empty?
        raise ArgumentError, "numero_instalacion is required" if numero_instalacion.nil?

        # En un lugar pone obligatorio y en otro opcional, se deja como obligatorio
        raise ArgumentError, "tipo_uso_posible_solo_verifactu is required" if tipo_uso_posible_solo_verifactu.nil?
        raise ArgumentError, "tipo_uso_posible_multi_ot is required" if tipo_uso_posible_multi_ot.nil?
        raise ArgumentError, "indicador_multi_ot is required" if indicador_multi_ot.nil?

        raise ArgumentError, "nombre_razon debe ser una String" unless nombre_razon.is_a?(String)
        raise ArgumentError, "nombre_razon debe tener un maximo de 120 caracteres" if nombre_razon.length > 120

        if nif
          Verifactu::Helper::Validador.validar_nif(nif)
        elsif id_otro
          raise ArgumentError, "id_otro debe ser una instancia de IDOtro" unless id_otro.is_a?(IDOtro)
          raise ArgumentError, "el propietario del sistema informático debe estar censado" if id_otro.id_type == "07"
        end

        if nombre_sistema_informatico
          raise ArgumentError, "nombre_sistema_informatico debe ser una String" unless nombre_sistema_informatico.is_a?(String)
          raise ArgumentError, "nombre_sistema_informatico debe tener un maximo de 20 caracteres" if nombre_sistema_informatico.length > 20
        end

        raise ArgumentError, "id_sistema_informatico debe ser una String" unless id_sistema_informatico.is_a?(String)
        raise ArgumentError, "id_sistema_informatico debe tener dos 2 caracteres" unless id_sistema_informatico.length == 2

        raise ArgumentError, "version debe ser una String" unless version.is_a?(String)
        raise ArgumentError, "version debe tener un maximo de 50 caracteres" if version.length > 50

        raise ArgumentError, "numero_instalacion debe ser una String" unless numero_instalacion.is_a?(String)
        raise ArgumentError, "numero_instalacion debe tener un maximo de 100 caracteres" if numero_instalacion.length > 100

        if tipo_uso_posible_solo_verifactu
          raise ArgumentError, "tipo_uso_posible_solo_verifactu debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(tipo_uso_posible_solo_verifactu.upcase)
        end

        if tipo_uso_posible_multi_ot
          raise ArgumentError, "tipo_uso_posible_multi_ot debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(tipo_uso_posible_multi_ot.upcase)
        end

        if indicador_multi_ot
          raise ArgumentError, "indicador_multi_ot debe estar en #{Verifactu::Config::L14.join(', ')}" unless Verifactu::Config::L14.include?(indicador_multi_ot.upcase)
        end

        @nombre_razon = nombre_razon
        @nif = nif
        @nombre_sistema_informatico = nombre_sistema_informatico
        @id_sistema_informatico = id_sistema_informatico.upcase
        @version = version
        @numero_instalacion = numero_instalacion
        @tipo_uso_posible_solo_verifactu = tipo_uso_posible_solo_verifactu.upcase
        @tipo_uso_posible_multi_ot = tipo_uso_posible_multi_ot.upcase
        @indicador_multi_ot = indicador_multi_ot.upcase
      end
    end
  end
end
