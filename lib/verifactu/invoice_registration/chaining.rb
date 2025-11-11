module Verifactu
  module InvoiceRegistration
    class Chaining
      attr_reader :first_record, :issuer_id, :series_number, :issue_date, :fingerprint
      private_class_method :new

      # Creates an instance of Chaining for the first record.
      # @return [Chaining] Instance of Chaining for the first record
      def self.crea_encadenamiento_primer_registro
        new(first_record: 'S')
      end

      # Creates an instance of Chaining for a subsequent record.
      # @param [String] issuer_id ID of the invoice issuer.
      # @param [String] series_number Invoice series number.
      # @param [String] issue_date Invoice issue date.
      # @param [String] fingerprint Fingerprint of the previous record.
      # @return [Chaining] Instance of Chaining for a subsequent record
      def self.crea_encadenamiento_registro_anterior(issuer_id:, series_number:, issue_date:, fingerprint:)
        raise Verifactu::VerifactuError, "issuer_id is required" if issuer_id.nil?
        raise Verifactu::VerifactuError, "series_number is required" if series_number.nil?
        raise Verifactu::VerifactuError, "issue_date is required" if issue_date.nil?
        raise Verifactu::VerifactuError, "fingerprint is required" if fingerprint.nil?

        Helper::Validador.validar_nif(issuer_id)

        raise Verifactu::VerifactuError, "series_number must be a String" unless Verifactu::Helper::Validador.cadena_valida?(series_number)
        raise Verifactu::VerifactuError, "series_number must have maximum 60 characters" if series_number.length > 60

        Helper::Validador.validar_fecha(issue_date)
        raise Verifactu::VerifactuError, "issue_date must not be earlier than 28/10/2024" if issue_date < Date.new(2024, 10, 28)

        raise Verifactu::VerifactuError, "series_number must contain only printable ASCII characters" unless series_number.ascii_only? && series_number.chars.all? { |char| char.ord.between?(32, 126) }

        raise Verifactu::VerifactuError, "fingerprint must be a String" unless Verifactu::Helper::Validador.cadena_valida?(fingerprint)
        raise Verifactu::VerifactuError, "fingerprint must have 64 hexadecimal characters" if fingerprint.length != 64 || !fingerprint.upcase.match?(/\A[A-F0-9]{64}\z/)

        registro = new(first_record: 'N')
        registro.instance_variable_set(:@issuer_id, issuer_id)
        registro.instance_variable_set(:@series_number, series_number)
        registro.instance_variable_set(:@issue_date, issue_date.strftime('%d-%m-%Y'))
        registro.instance_variable_set(:@fingerprint, fingerprint)

        registro

      end

      private

      def initialize(first_record: 'N')
        raise Verifactu::VerifactuError, "first_record must be 'S' or 'N'" unless ['S', 'N'].include?(first_record)
        @first_record = first_record
      end


    end
  end
end
