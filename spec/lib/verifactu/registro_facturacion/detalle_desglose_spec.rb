RSpec.describe Verifactu::RegistroFacturacion::DetalleDesglose do
  describe '.validar_calificacion_operacion' do
    it 'fails if calificacion_operacion is S2 and tipo_impositivo is not 0' do
      expect do
        described_class.validar_calificacion_operacion(
          calificacion_operacion: 'S2',
          tipo_impositivo: '10',
          cuota_repercutida: '0'
        )
      end.to raise_error(Verifactu::VerifactuError, "DetalleDesglose - calificacionOperacion S2 - tipo_impositivo debe ser 0")
    end

    it 'fails if calificacion_operacion is S2 and cuota_repercutida is not 0' do
      expect do
        described_class.validar_calificacion_operacion(
          calificacion_operacion: 'S2',
          tipo_impositivo: '0',
          cuota_repercutida: '100.0'
        )
      end.to raise_error(Verifactu::VerifactuError, "DetalleDesglose - calificacionOperacion S2 - cuota_repercutida debe ser 0")
    end

    it 'passes if calificacion_operacion is S2 and cuota_repercutida/tipo_impositivo are 0' do
      expect do
        described_class.validar_calificacion_operacion(
          calificacion_operacion: 'S2',
          tipo_impositivo: '0',
          cuota_repercutida: '0'
        )
      end.not_to raise_error
    end

    it 'passes if calificacion_operacion is S2 and cuota_repercutida/tipo_impositivo are 0.0' do
      expect do
        described_class.validar_calificacion_operacion(
          calificacion_operacion: 'S2',
          tipo_impositivo: '0.0',
          cuota_repercutida: '0.0'
        )
      end.not_to raise_error
    end
  end
end