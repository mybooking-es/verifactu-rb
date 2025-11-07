require 'spec_helper'

RSpec.describe Verifactu::Cabecera do

  describe '#initialize' do

    it "validates a header without representative" do
      cabecera = cabecera_sin_representante
    end

  end

end
