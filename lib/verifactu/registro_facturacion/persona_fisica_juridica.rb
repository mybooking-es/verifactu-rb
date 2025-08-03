module Verifactu
  module RegistroFacturacion
    # Representa <sum1:PersonaFisicaJuridica>
    class PersonaFisicaJuridica
      attr_reader :nombre_razon, :nif, :id_otro

      private_class_method :new

      #
      # Crea una instancia de PersonaFisicaJuridica a partir de un NIF o IDOtro.
      #
      # @param [String] nombre_razon Nombre o razón social de la persona física o jurídica.
      # @param [String] nif NIF de la persona física o jurídica.
      def self.create_from_nif(nombre_razon:, nif:)
        Verifactu::Helper::Validador.validar_nif(nif)
        @persona_fisica_juridica = new(nombre_razon: nombre_razon)
        @persona_fisica_juridica.instance_variable_set(:@nif, nif)
        @persona_fisica_juridica
      end

      #
      # Crea una instancia de PersonaFisicaJuridica a partir de un IDOtro.
      # @param [String] nombre_razon Nombre o razón social de la persona física o jurídica.
      # @param [IDOtro] id_otro IDOtro de la persona física o jurídica
      def self.create_from_id_otro(nombre_razon:, id_otro:)
        raise ArgumentError, "id_otro debe ser una instancia de IDOtro" unless id_otro.is_a?(IDOtro)
        @persona_fisica_juridica = new(nombre_razon: nombre_razon)
        @persona_fisica_juridica.instance_variable_set(:@id_otro, id_otro)
        @persona_fisica_juridica
      end

      private

      def initialize(nombre_razon:)
        raise ArgumentError, "nombre_razon is required" if nombre_razon.nil? || nombre_razon.empty?
        raise ArgumentError, "nombre_razon must be a string" unless nombre_razon.is_a?(String)
        raise ArgumentError, "nombre_razon debe tener un maximo de 120 caracteres" if nombre_razon.length > 120
        @nombre_razon = nombre_razon
      end

    end
  end
end
