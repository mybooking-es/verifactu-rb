require 'spec_helper'

RSpec.describe Verifactu::HighRecordBuilder do
  describe '.build_standard' do

    it 'creates a regular invoice' do

      # Generate the fingerprint for the invoice registration
      huella = huella_inicial

      # Create a high invoice with the necessary data
      factura = registro_alta_factura_valido(huella)

      expect(factura).to be_a(Verifactu::InvoiceRegistration::HighRecord)
      expect(factura.invoice_id.issuer_id).to eq('B12345674')
      expect(factura.invoice_id.series_number).to eq('NC202500051')
      expect(factura.invoice_id.issue_date).to eq('22-07-2025')
      expect(factura.issuer_name).to eq('Mi empresa SL')
      expect(factura.invoice_type).to eq('F1')
      expect(factura.operation_description).to eq('Factura Reserva 2.731 - 22/07/2025 10:00 - 22/10/2025 10:00 - AAA-0009')
      expect(factura.recipients.first.business_name).to eq('Brad Stark')
      expect(factura.recipients.first.nif).to eq('55555555K')
      expect(factura.breakdown.first.regime_key).to eq('01')
      expect(factura.breakdown.first.operation_qualification).to eq('S1')
      expect(factura.breakdown.first.tax_rate).to eq('21')
      expect(factura.breakdown.first.taxable_base_o_importe_no_sujeto).to eq('264.46')
      expect(factura.breakdown.first.charged_tax).to eq('55.54')
      expect(factura.total_tax).to eq('55.54')
    end

  end

end
