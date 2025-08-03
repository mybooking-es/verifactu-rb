module Verifactu
  module RegistroFacturacion
    #
    # It represents registro facturación anulación at Verifactu.
    # It is not implemented yet
    #
    class RegistroAnulacion
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

      def initialize(id_factura:, ref_externa: nil, sin_registro_previo: 'N', rechazo_previo: 'N', generado_por: nil, generador: nil, sistema_informatico:, fecha_hora_huso_gen_anulacion:, tipo_huella:, huella:, signature: nil)

        raise ArgumentError, "id_factura es obligatorio" if id_factura.nil?
        raise ArgumentError, "id_factura debe ser una instancia de IDFactura" unless id_factura.is_a?(Verifactu::IDFactura)

        if ref_externa
          raise ArgumentError, "ref_externa debe ser una String" unless ref_externa.is_a?(String)
          raise ArgumentError, "ref_externa debe tener un maximo de 60 caracteres" if ref_externa.length > 60
        end

        if sin_registro_previo
          raise ArgumentError, "sin_registro_previo debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(sin_registro_previo.upcase)
        end

        if rechazo_previo
          raise ArgumentError, "rechazo_previo debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(rechazo_previo.upcase)
        end

        if generado_por
          raise ArgumentError, "generado_por debe estar en #{Verifactu::Config::L16.join(', ')}" unless Verifactu::Config::L16.include?(generado_por.upcase)
          self.validar_generador(generador, generado_por)
        end

        # Validaciones de sistema_informatico
        raise ArgumentError, "sistema_informatico is required" if sistema_informatico.nil?
        raise ArgumentError, "sistema_informatico debe ser una instancia de SistemaInformatico" unless sistema_informatico.is_a?(SistemaInformatico)

        # Validaciones de fecha_hora_huso_gen_registro
        raise ArgumentError, "fecha_hora_huso_gen_registro is required" if fecha_hora_huso_gen_registro.nil?
        unless fecha_hora_huso_gen_registro.is_a?(String) && fecha_hora_huso_gen_registro.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|[+-]\d{2}:\d{2})\z/)
          raise ArgumentError, "fecha_hora_huso_gen_registro debe estar en formato ISO 8601: YYYY-MM-DDThh:mm:ssTZD (ej: 2024-01-01T19:20:30+01:00)"
        end

        # Validaciones de tipo_huella
        raise ArgumentError, "tipo_huella is required" if tipo_huella.nil?
        raise ArgumentError, "tipo_huella debe estar entre #{Verifactu::Config::L12.join(', ')}" unless Verifactu::Config::L12.include?(tipo_huella.upcase)

        # Validaciones de huella
        raise ArgumentError, "huella is required" if huella.nil?
        # TODO: Verificar que huella cumple con los requisitos del documento Especificaciones técnicas para generación de la huella o «hash» de los registros de facturación

        # Validaciones de signature
        if signature
          # TODO: Verificar que signature cumple con formato del "schema", en http://www.w3.org/2000/09/xmldsig#
        end

        @id_version = Verifactu::Config::ID_VERSION
        @id_factura = id_factura
        @ref_externa = ref_externa
        @sin_registro_previo = sin_registro_previo
        @rechazo_previo = rechazo_previo
        @generado_por = generado_por
        @generador = generador
        @encadenamiento = Verifactu::Helper::Generador.generar_encadenamiento()
        @sistema_informatico = sistema_informatico
        @fecha_hora_huso_gen_anulacion = fecha_hora_huso_gen_anulacion
        @tipo_huella = tipo_huella
        @huella = huella
        @signature = signature
      end

      private
      def validar_generador(generador, generado_por)
        raise ArgumentError, "generador debe ser una instancia de PersonaFisicaJuridica" unless generador.is_a?(PersonaFisicaJuridica)
        case generado_por.upcase
        when 'E'
          raise ArgumentError, "generador debe tener un NIF" if generador.nif.nil?
        when 'D'
          # La validacion que se pide aqui ya es una verificacion de IDOtro
        when 'T'
          raise ArgumentError, "generador debe estar censado" if generador.id_otro&.id_type == '07'
        end
      end
    end
  end
end
