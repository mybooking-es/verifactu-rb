require 'spec_helper'


RSpec.describe Verifactu::RegistroAltaXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of RegistroAlta' do

      # Genera la huella para el registro de alta de una factura
      huella = huella_inicial

      # Crea una factura de alta con los datos necesarios
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Genera el XML
      Verifactu::RegistroAltaXmlBuilder.build(registo_alta_factura)

    end

  end
end
