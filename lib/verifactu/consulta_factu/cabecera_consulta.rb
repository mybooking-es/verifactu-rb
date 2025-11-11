module Verifactu
  module ConsultaFactu
    class CabeceraConsulta
      attr_reader :id_version, :obligado_emision, :destinatario, :indicador_representante

      private_class_method :new

      def self.cabecera_obligado_emisor(obligado_emision:, indicador_representante: nil)
        raise Verifactu::VerifactuError, "obligado_emision is required" if obligado_emision.nil?
        raise Verifactu::VerifactuError, "obligado_emision must be PersonaFisicaJuridica" unless obligado_emision.is_a?(Verifactu::InvoiceRegistration::LegalEntity)
        raise Verifactu::VerifactuError, "obligado_emision must have nif" if obligado_emision.nif.nil?
        @cabecera = new(indicador_representante)
        @cabecera.instance_variable_set(:@obligado_emision, obligado_emision)
        @cabecera
      end

      def self.cabecera_destinatario(destinatario:, indicador_representante: nil)
        raise Verifactu::VerifactuError, "destinatario is required" if destinatario.nil?
        raise Verifactu::VerifactuError, "destinatario must be PersonaFisicaJuridica" unless destinatario.is_a?(Verifactu::InvoiceRegistration::LegalEntity)
        raise Verifactu::VerifactuError, "destinatario must have nif" if destinatario.nif.nil?
        @cabecera = new(indicador_representante)
        @cabecera.instance_variable_set(:@destinatario, destinatario)
        @cabecera
      end

      private

      def initialize(indicador_representante = nil)
        if indicador_representante
          raise Verifactu::VerifactuError "indicador_representante debe estar entre #{Verifactu::Config::L1C.join(', ')} o nil" if Verifactu::Config::L1C.include(indicador_representante)
        end
        @id_version = Verifactu::Config::ID_VERSION
        @indicador_representante = indicador_representante
      end


    end

  end

end
