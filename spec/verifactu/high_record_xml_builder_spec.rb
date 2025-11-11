require 'spec_helper'


RSpec.describe Verifactu::HighRecordXmlBuilder do
  describe '.build' do

    it 'creates a valid XML representation of HighRecord' do

      # Generate the fingerprint for the high invoice record
      huella = huella_inicial

      # Create a high invoice with the necessary data
      registo_alta_factura = registro_alta_factura_valido(huella)

      # Generate el XML
      x = Verifactu::HighRecordXmlBuilder.build(registo_alta_factura)
      #p "xml: #{x.root.to_xml}"

    end

  end
end
