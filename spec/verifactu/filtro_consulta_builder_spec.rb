require 'spec_helper'

RSpec.describe Verifactu::FiltroConsultaBuilder do
  describe '.build_standa' do

    it 'creates a simple query filter' do

      # Generate the fingerprint for the high invoice record
      filtro = filtro_consulta_simple_valida

      expect(filtro).to be_a(Verifactu::ConsultaFactu::FiltroConsulta)
      expect(filtro.periodo_imputacion).to be_a(Verifactu::ConsultaFactu::PeriodoImputacion)
      expect(filtro.periodo_imputacion.periodo).to eq('02')
      expect(filtro.periodo_imputacion.ejercicio).to eq('2025')

    end

    it 'creates a complex query filter' do
      filtro = filtro_consulta_compleja_valida

      expect(filtro).to be_a(Verifactu::ConsultaFactu::FiltroConsulta)
      expect(filtro.periodo_imputacion).to be_a(Verifactu::ConsultaFactu::PeriodoImputacion)
      expect(filtro.periodo_imputacion.periodo).to eq('02')
      expect(filtro.periodo_imputacion.ejercicio).to eq('2025')
      expect(filtro.series_number).to eq('A12')
      expect(filtro.contraparte).to be_a(Verifactu::InvoiceRegistration::LegalEntity)
      expect(filtro.contraparte.business_name).to eq('Brad Stark')
      expect(filtro.contraparte.nif).to eq('55555555K')
      expect(filtro.issue_date).to be_a(Verifactu::ConsultaFactu::FechaExpedicionFactura)
      expect(filtro.issue_date.fecha_expedicion).to eq('20-02-2025')
      expect(filtro.external_ref).to eq('Mybooking-doralauto-menorca')
    end

  end

end
