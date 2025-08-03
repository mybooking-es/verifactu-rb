require 'spec_helper'

RSpec.describe Verifactu::Cabecera do

  describe '#initialize' do

    it "valida una cabecera sin representante" do
      cabecera = cabecera_sin_representante
    end

  end

end
