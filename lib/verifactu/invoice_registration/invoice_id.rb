module Verifactu
  module InvoiceRegistration
    # Represents <sum1:IDFactura>
    class InvoiceId
      attr_reader :issuer_id, :series_number, :issue_date

      def initialize(issuer_id:, series_number:, issue_date:)
        raise Verifactu::VerifactuError, "issuer_id is required" if issuer_id.nil?
        raise Verifactu::VerifactuError, "series_number is required" if series_number.nil?
        raise Verifactu::VerifactuError, "issue_date is required" if issue_date.nil?

        Helper::Validador.validar_nif(issuer_id)
        # The NIF of the IDEmisorFactura field must be the same as the NIF field of the ObligadoEmision group in the Cabecera block.

        raise Verifactu::VerifactuError, "series_number must be a valid String" unless Verifactu::Helper::Validador.cadena_valida?(series_number)
        caracteres_no = ['"', "'", '<', '>', '=']        
        raise Verifactu::VerifactuError, "series_number cannot contain the characters: #{caracteres_no.join(", ")}" if series_number.chars.any? { |char| caracteres_no.include?(char) }
        raise Verifactu::VerifactuError, "series_number cannot be empty" if series_number.empty?
        raise Verifactu::VerifactuError, "series_number must have a maximum of 60 characters" if series_number.length > 60

        Helper::Validador.validar_fecha_pasada(issue_date)
        raise Verifactu::VerifactuError, "issue_date must not be earlier than 28/10/2024" if Date.strptime(issue_date, '%d-%m-%Y') < Date.new(2024, 10, 28)
        # If Impuesto = "01" (IVA), "03" (IGIC) or not filled in (considered "01" - IVA), the
        # FechaExpedicionFactura can only be earlier than FechaOperacion if ClaveRegimen = "14" or "15".

        raise Verifactu::VerifactuError, "series_number must contain only printable ASCII characters" unless series_number.ascii_only? && series_number.chars.all? { |char| char.ord.between?(32, 126) }

        @issuer_id = issuer_id
        @series_number = series_number
        @issue_date = issue_date
      end
    end
  end
end
