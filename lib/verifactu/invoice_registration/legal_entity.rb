module Verifactu
  module InvoiceRegistration
    # Represents <sum1:PersonaFisicaJuridica>
    class LegalEntity
      attr_reader :business_name, :nif, :other_id

      private_class_method :new

      #
      # Creates an instance of LegalEntity from a NIF.
      #
      # @param [String] business_name Name or business name of the individual or legal entity.
      # @param [String] nif NIF of the individual or legal entity.
      def self.create_from_nif(business_name:, nif:)
        Verifactu::Helper::Validador.validar_nif(nif)
        @persona_fisica_juridica = new(business_name: business_name)
        @persona_fisica_juridica.instance_variable_set(:@nif, nif)
        @persona_fisica_juridica
      end

      #
      # Creates an instance of LegalEntity from an OtherId.
      # @param [String] business_name Name or business name of the individual or legal entity.
      # @param [OtherId] other_id OtherId of the individual or legal entity
      def self.create_from_id_otro(business_name:, other_id:)
        raise Verifactu::VerifactuError, "other_id must be an instance of OtherId" unless other_id.is_a?(OtherId)
        @persona_fisica_juridica = new(business_name: business_name)
        @persona_fisica_juridica.instance_variable_set(:@other_id, other_id)
        @persona_fisica_juridica
      end

      private

      def initialize(business_name:)
        raise Verifactu::VerifactuError, "business_name is required" if business_name.nil? || business_name.empty?
        raise Verifactu::VerifactuError, "business_name must be a string" unless Verifactu::Helper::Validador.cadena_valida?(business_name)
        raise Verifactu::VerifactuError, "business_name must have a maximum of 120 characters" if business_name.length > 120
        @business_name = business_name
      end

    end
  end
end
