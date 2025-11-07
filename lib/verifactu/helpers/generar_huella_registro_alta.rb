require 'digest'
module Verifactu
  module Helper
    #
    # Generate the fingerprint for the invoice high record.
    #
    class GenerarHuellaRegistroAlta

      # Executes the generation of the fingerprint for the invoice high record.
      # @param [String] issuer_id Invoice issuer ID.
      # @param [String] series_number Invoice series number.
      # @param [String] issue_date Invoice issue date in 'dd-MM-yyyy' format.
      # @param [String] invoice_type Invoice type, e.g., 'F1' for regular invoice.
      # @param [String] total_tax Total tax amount of the invoice.
      # @param [String] total_amount Total amount of the invoice.
      # @param [String] fingerprint Invoice fingerprint, optional. (blank for first record or previous one)
      # @param [String] record_generation_datetime Record generation date and time in ISO 8601 format.
      # @return [String] The generated fingerprint as a SHA256 hash.
      def self.execute(issuer_id:, series_number:, issue_date:, invoice_type:, total_tax:,
                       total_amount:, fingerprint:, record_generation_datetime:)

        # Prepare the text to generate the fingerprint
        elements = []
        elements << "IDEmisorFactura=#{issuer_id}"
        elements << "NumSerieFactura=#{series_number}"
        elements << "FechaExpedicionFactura=#{issue_date}"
        elements << "TipoFactura=#{invoice_type}"
        elements << "CuotaTotal=#{total_tax}"
        elements << "ImporteTotal=#{total_amount}"
        elements << "Huella=#{fingerprint ? fingerprint : ''}"
        elements << "FechaHoraHusoGenRegistro=#{record_generation_datetime}"
        text = elements.join('&')

        # Generate the fingerprint as a SHA256 hash of the concatenated text
        Digest::SHA256.hexdigest(text).upcase

      end

    end
  end
end
