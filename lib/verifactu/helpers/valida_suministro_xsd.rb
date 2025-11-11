module Verifactu
  module Helpers
    class ValidaSuministroXSD

      # Validates the XML against the XSD schema
      # @param xml_str [String] XML string to validate
      # @return [Hash] Result of the validation, with keys :valid, :errors, and :error_type if applicable
      # @example
      #   result = Verifactu::Helpers::ValidaSuministroXSD.execute(xml_str)
      #   if result[:valid]
      #     puts "XML is valid"
      #   else
      #     puts "XML is invalid: #{result[:errors].join(', ')}"
      #     puts "Error type: #{result[:error_type]}" if result[:error_type]
      #   end
      def self.execute(xml_str)

        # Cargar el esquema XSD desde el fichero local
        xsd_dir = File.expand_path('../../../../', __FILE__)
        xsd_path = File.join(xsd_dir, 'SuministroLR.xsd')
        xsd = XsdLoader.new(xsd_path).load

        # Parsear el XML de entrada
        xml_doc = Nokogiri::XML(xml_str) { |config| config.strict }

        # Validate el XML contra el esquema XSD
        errors = xsd.validate(xml_doc)
        if errors.empty?
          return {valid: true}
        else
          error_messages = errors.map { |error| error.message }
          return {valid: false, errors: error_messages}
        end
      rescue Nokogiri::XML::SyntaxError => e
        return {
          valid: false,
          error_type: :XMLSyntaxError,
          errors: ["Error de sintaxis en el XML: #{e.message}"]
        }
      rescue StandardError => e
        return {
          valid: false,
          error_type: :StandardError,
          errors: ["Error inesperado: #{e.message}"]
        }
      end

    end
  end
end
