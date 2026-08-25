require 'spec_helper'

#
# Fija dos contratos que estaban rotos y que solo se veian al correr la suite
# fuera de una aplicacion Rails-like:
#
#   1. `Validador.hoy` no puede asumir que ActiveSupport este cargada. La gem no
#      la declara como dependencia, asi que `Time.zone` puede no existir.
#   2. `cadena_valida` acepta Unicode imprimible, no solo ASCII. Los tipos de
#      texto del XSD de AEAT solo restringen `maxLength`.
#
RSpec.describe Verifactu::Helper::Validador do

  describe '.hoy' do

    it 'devuelve una fecha' do
      expect(described_class.hoy).to be_a(Date)
    end

    it 'usa Time.zone.today cuando la aplicacion anfitriona lo aporta' do
      zone = double('TimeZone', today: Date.new(2026, 8, 25))
      allow(Time).to receive(:respond_to?).with(:zone).and_return(true)
      allow(Time).to receive(:zone).and_return(zone)

      expect(described_class.hoy).to eq(Date.new(2026, 8, 25))
    end

    it 'cae a Date.today cuando la aplicacion no ha fijado zona' do
      allow(Time).to receive(:respond_to?).with(:zone).and_return(true)
      allow(Time).to receive(:zone).and_return(nil)

      expect(described_class.hoy).to eq(Date.today)
    end

    it 'cae a Date.today cuando ActiveSupport no esta cargada' do
      allow(Time).to receive(:respond_to?).with(:zone).and_return(false)

      expect(described_class.hoy).to eq(Date.today)
    end

  end

  describe '.cadena_valida?' do

    # Estos nombres los rechazaba la version con `ascii_only?`, y la AEAT los
    # acepta: en la aplicacion se traducia en dejar la factura sin enviar.
    ['Compania Munoz S.L.', "Compañía Muñoz S.L.", "José Peñíscola García",
     "Autos Íñigo", "Instalación 1", "Òscar Pujolàs", "Aïda Gómez"].each do |nombre|
      it "acepta #{nombre}" do
        expect(described_class.cadena_valida?(nombre)).to be true
      end
    end

    it 'acepta ASCII normal' do
      expect(described_class.cadena_valida?('Karyasala SL')).to be true
    end

    it 'acepta < > = (AEAT los volvio a permitir el 23/10/2025)' do
      expect(described_class.cadena_valida?('Alquiler <A> = 1')).to be true
    end

    it 'rechaza caracteres de control, que romperian el XML' do
      expect(described_class.cadena_valida?("Karyasala\u0001SL")).to be false
    end

    it 'rechaza saltos de linea' do
      expect(described_class.cadena_valida?("Karyasala\nSL")).to be false
    end

    it 'rechaza nil' do
      expect(described_class.cadena_valida?(nil)).to be false
    end

    it 'rechaza lo que no es String' do
      expect(described_class.cadena_valida?(42)).to be false
    end

  end

  describe 'la cadena llega intacta a quien construye el XML' do

    it 'conserva los acentos del nombre del destinatario' do
      destinatario = Verifactu::RegistroFacturacion::PersonaFisicaJuridica.create_from_nif(
        nombre_razon: "Compañía Muñoz S.L.", nif: '55555555K')

      expect(destinatario.nombre_razon).to eq("Compañía Muñoz S.L.")
    end

  end

end
