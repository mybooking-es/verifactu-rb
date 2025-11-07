module Verifactu
  module InvoiceRegistration
    #
    # It represents a cancellation invoice registration at Verifactu.
    # It is not implemented yet
    #
    class CancellationRecord
      attr_reader :id_version,
                  :id_factura,
                  :ref_externa,
                  :sin_registro_previo,
                  :rechazo_previo,
                  :generado_por,
                  :generador,
                  :encadenamiento,
                  :sistema_informatico,
                  :fecha_hora_huso_gen_anulacion,
                  :tipo_huella,
                  :huella,
                  :signature

      def initialize(id_factura:, ref_externa: nil, sin_registro_previo: 'N', rechazo_previo: 'N', generado_por: nil, generador: nil, sistema_informatico:, fecha_hora_huso_gen_anulacion:, tipo_fingerprint:, fingerprint:, signature: nil)

        raise Verifactu::VerifactuError, "id_factura is required" if id_factura.nil?
        raise Verifactu::VerifactuError, "id_factura must be an instance of IDFactura" unless id_factura.is_a?(Verifactu::IDFactura)

        if ref_externa
          raise Verifactu::VerifactuError, "ref_externa must be a String" unless Verifactu::Helper::Validador.cadena_valida?(ref_externa)
          raise Verifactu::VerifactuError, "ref_externa must have a maximum of 60 caracteres" if ref_externa.length > 60
        end

        if sin_registro_previo
          raise Verifactu::VerifactuError, "sin_registro_previo must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(sin_registro_previo.upcase)
        end

        if rechazo_previo
          raise Verifactu::VerifactuError, "rechazo_previo must be in #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(rechazo_previo.upcase)
        end

        if generado_por
          raise Verifactu::VerifactuError, "generado_por must be in #{Verifactu::Config::L16.join(', ')}" unless Verifactu::Config::L16.include?(generado_por.upcase)
          self.validar_generador(generador, generado_por)
        end

        # Validation of sistema_informatico
        raise Verifactu::VerifactuError, "sistema_informatico is required" if sistema_informatico.nil?
        raise Verifactu::VerifactuError, "sistema_informatico must be an instance of SistemaInformatico" unless sistema_informatico.is_a?(InformationSystem)

        # Validation of fecha_hora_huso_gen_registro
        raise Verifactu::VerifactuError, "fecha_hora_huso_gen_registro is required" if fecha_hora_huso_gen_registro.nil?
        raise Verifactu::VerifactuError, "fecha_hora_huso_gen_registro must be in formato ISO 8601: YYYY-MM-DDThh:mm:ssTZD (ej: 2024-01-01T19:20:30+01:00)" unless Verifactu::Helper::Validador.fecha_hora_huso_gen_valida?(fecha_hora_huso_gen_registro)

        # Validation of tipo_huella
        raise Verifactu::VerifactuError, "tipo_huella is required" if tipo_huella.nil?
        raise Verifactu::VerifactuError, "tipo_huella must be intre #{Verifactu::Config::L12.join(', ')}" unless Verifactu::Config::L12.include?(tipo_huella.upcase)

        # Validation of huella
        raise Verifactu::VerifactuError, "huella is required" if huella.nil?
        # TODO: Verify that fingerprint complies with the requirements of the technical specifications document for generating the fingerprint or "hash" of billing records

        # Validation of signature
        if signature
          # TODO: Verify that signature complies with the "schema" format at http://www.w3.org/2000/09/xmldsig#
        end

        @id_version = Verifactu::Config::ID_VERSION
        @invoice_id = id_factura
        @external_ref = ref_externa
        @sin_registro_previo = sin_registro_previo
        @previous_rejection = rechazo_previo
        @generado_por = generado_por
        @generador = generador
        @chaining = Verifactu::Helper::Generador.generar_encadenamiento()
        @information_system = sistema_informatico
        @fecha_hora_huso_gen_anulacion = fecha_hora_huso_gen_anulacion
        @tipo_huella = tipo_huella
        @huella = huella
        @signature = signature
      end

      private
      def validate_generator(generador, generado_por)
        raise Verifactu::VerifactuError, "generador must be an instance of PersonaFisicaJuridica" unless generador.is_a?(LegalEntity)
        case generado_por.upcase
        when 'E'
          raise Verifactu::VerifactuError, "generador must have a NIF" if generador.nif.nil?
        when 'D'
          # The validation required here is already a verification of IDOtro
        when 'T'
          raise Verifactu::VerifactuError, "generador must be registered" if generador.other_id&.id_type == '07'
        end
      end
    end
  end
end
