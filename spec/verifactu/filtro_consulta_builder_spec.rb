require 'spec_helper'

RSpec.describe Verifactu::RegistroAltaBuilder do
  describe '.build_standa' do

    it 'crea un filtro consulta simple' do

      # Genera la huella para el registro de alta de una factura
      filtro = filtro_consulta_simple_valida

      expect(filtro).to be_a(Verifactu::ConsultaFactu::FiltroConsulta)
      expect(filtro.periodo_imputacion).to be_a(Verifactu::ConsultaFactu::PeriodoImputacion)
      expect(filtro.periodo_imputacion.periodo).to eq('02')
      expect(filtro.periodo_imputacion.ejercicio).to eq('2025')

    end

    it 'crea un filtro consulta complejo' do
      filtro = filtro_consulta_compleja_valida

      expect(filtro).to be_a(Verifactu::ConsultaFactu::FiltroConsulta)
      expect(filtro.periodo_imputacion).to be_a(Verifactu::ConsultaFactu::PeriodoImputacion)
      expect(filtro.periodo_imputacion.periodo).to eq('02')
      expect(filtro.periodo_imputacion.ejercicio).to eq('2025')
      expect(filtro.num_serie_factura).to eq('A12')
      expect(filtro.contraparte).to be_a(Verifactu::RegistroFacturacion::PersonaFisicaJuridica)
      expect(filtro.contraparte.nombre_razon).to eq('Brad Stark')
      expect(filtro.contraparte.nif).to eq('55555555K')
      expect(filtro.fecha_expedicion_factura).to be_a(Verifactu::ConsultaFactu::FechaExpedicionFactura)
      expect(filtro.fecha_expedicion_factura.fecha_expedicion).to eq('20-02-2025')
      expect(filtro.ref_externa).to eq('Mybooking-doralauto-menorca')
    end

  end

end
