module Verifactu
  module InvoiceRegistration
    #
    # It represents the SIF (Sistema de Información Fiscal) class in the Verifactu module.
    #
    class InformationSystem
      attr_reader :business_name, :nif, :other_id, :system_name,
                  :system_id, :version, :installation_number,
                  :usage_type_verifactu_only, :usage_type_multi_ot, :multiple_ot_indicator

      # Initializes a new instance of the InformationSystem class.
      #
      # @param business_name [String] The name or reason of the entity.
      # @param nif [String] The NIF (Tax Identification Number) of the entity.
      # @param system_name [String] The name of the information system.
      # @param system_id [String] The ID of the information system.
      # @param version [String] The version of the information system.
      # @param installation_number [String] The installation number of the information system.
      # @param usage_type_verifactu_only [String] The possible use type for Verifactu only.
      # @param usage_type_multi_ot [String] The possible use type for multiple systems.
      # @param multiple_ot_indicator [String] The multiple OT indicator.
      #
      def initialize(business_name:, nif: nil, other_id: nil, system_name: nil, system_id:,
                    version:, installation_number:,
                    usage_type_verifactu_only:, usage_type_multi_ot:, multiple_ot_indicator:)
        raise Verifactu::VerifactuError, "business_name is required" if business_name.nil? || business_name.empty?
        raise Verifactu::VerifactuError, "nif or other_id is required" if nif.nil? && other_id.nil?
        raise Verifactu::VerifactuError, "only nif or other_id can be defined, not both" if nif && other_id
        raise Verifactu::VerifactuError, "system_id is required" if system_id.nil?
        raise Verifactu::VerifactuError, "version is required" if version.nil? || version.empty?
        raise Verifactu::VerifactuError, "installation_number is required" if installation_number.nil?

        # In one place it says required and in another optional, left as required
        raise Verifactu::VerifactuError, "usage_type_verifactu_only is required" if usage_type_verifactu_only.nil?
        raise Verifactu::VerifactuError, "usage_type_multi_ot is required" if usage_type_multi_ot.nil?
        raise Verifactu::VerifactuError, "multiple_ot_indicator is required" if multiple_ot_indicator.nil?

        raise Verifactu::VerifactuError, "business_name must be a String" unless Verifactu::Helper::Validador.cadena_valida?(business_name)
        raise Verifactu::VerifactuError, "business_name must have a maximum of 120 characters" if business_name.length > 120

        if nif
          Verifactu::Helper::Validador.validar_nif(nif)
        elsif other_id
          raise Verifactu::VerifactuError, "other_id must be an instance of OtherId" unless other_id.is_a?(OtherId)
          raise Verifactu::VerifactuError, "the information system owner must be registered" if other_id.id_type == "07"
        end

        if system_name
          raise Verifactu::VerifactuError, "system_name must be a String" unless Verifactu::Helper::Validador.cadena_valida?(system_name)
          raise Verifactu::VerifactuError, "system_name must have a maximum of 20 characters" if system_name.length > 20
        end

        raise Verifactu::VerifactuError, "system_id must be a String" unless Verifactu::Helper::Validador.cadena_valida?(system_id)
        raise Verifactu::VerifactuError, "system_id must have 2 characters" unless system_id.length == 2

        raise Verifactu::VerifactuError, "version must be a String" unless Verifactu::Helper::Validador.cadena_valida?(version)
        raise Verifactu::VerifactuError, "version must have a maximum of 50 characters" if version.length > 50

        raise Verifactu::VerifactuError, "installation_number must be a String" unless Verifactu::Helper::Validador.cadena_valida?(installation_number)
        raise Verifactu::VerifactuError, "installation_number must have a maximum of 100 characters" if installation_number.length > 100

        if usage_type_verifactu_only
          raise Verifactu::VerifactuError, "usage_type_verifactu_only must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(usage_type_verifactu_only.upcase)
        end

        if usage_type_multi_ot
          raise Verifactu::VerifactuError, "usage_type_multi_ot must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(usage_type_multi_ot.upcase)
        end

        if multiple_ot_indicator
          raise Verifactu::VerifactuError, "multiple_ot_indicator must be in #{Verifactu::Config::L14.join(', ')}" unless Verifactu::Config::L14.include?(multiple_ot_indicator.upcase)
        end

        @business_name = business_name
        @nif = nif
        @other_id = other_id
        @system_name = system_name
        @system_id = system_id.upcase
        @version = version
        @installation_number = installation_number
        @usage_type_verifactu_only = usage_type_verifactu_only.upcase
        @usage_type_multi_ot = usage_type_multi_ot.upcase
        @multiple_ot_indicator = multiple_ot_indicator.upcase
      end
    end
  end
end
