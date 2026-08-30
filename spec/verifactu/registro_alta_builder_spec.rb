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

    it 'crea una factura con un sistema informático con IDOtro' do

      # Genera la huella para el registro de alta de una factura
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      factura = registro_alta_factura_valido(huella) do |b|
        b.con_sistema_informatico(
          nombre_razon: 'Mi empresa SL', 
          id_otro: {
            codigo_pais: "DE",
            id: "123456789",
            id_type: "06"
          },
          nombre_sistema_informatico: 'Mi sistema', 
          id_sistema_informatico: 'MB',
          version: '1.0.0', 
          numero_instalacion: 'Instalacion 1',
          tipo_uso_posible_solo_verifactu: 'S', 
          tipo_uso_posible_multi_ot: 'S',
          indicador_multiples_ot: 'S'
        )
      end

      expect(factura.sistema_informatico.id_otro.codigo_pais).to eq('DE')
      expect(factura.sistema_informatico.id_otro.id).to eq('123456789')
      expect(factura.sistema_informatico.id_otro.id_type).to eq('06')
    end

  end

end
