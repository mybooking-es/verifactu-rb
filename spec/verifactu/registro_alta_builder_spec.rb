require 'spec_helper'

RSpec.describe Verifactu::RegistroAltaBuilder do
  describe '.build_standa' do

    it 'crea una factura ordinaria' do

      # Genera la huella para el registro de alta de una factura
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      factura = registro_alta_factura_valido(huella)

      expect(factura).to be_a(Verifactu::RegistroFacturacion::RegistroAlta)
      expect(factura.id_factura.id_emisor_factura).to eq('B12345674')
      expect(factura.id_factura.num_serie_factura).to eq('NC202500051')
      expect(factura.id_factura.fecha_expedicion_factura).to eq('22-07-2025')
      expect(factura.nombre_razon_emisor).to eq('Mi empresa SL')
      expect(factura.tipo_factura).to eq('F1')
      expect(factura.descripcion_operacion).to eq('Factura Reserva 2.731 - 22/07/2025 10:00 - 22/10/2025 10:00 - AAA-0009')
      expect(factura.destinatarios.first.nombre_razon).to eq('Brad Stark')
      expect(factura.destinatarios.first.nif).to eq('55555555K')
      expect(factura.desglose.first.clave_regimen).to eq('01')
      expect(factura.desglose.first.calificacion_operacion).to eq('S1')
      expect(factura.desglose.first.tipo_impositivo).to eq('21')
      expect(factura.desglose.first.base_imponible_o_importe_no_sujeto).to eq('264.46')
      expect(factura.desglose.first.cuota_repercutida).to eq('55.54')
      expect(factura.cuota_total).to eq('55.54')
    end

  end

end
