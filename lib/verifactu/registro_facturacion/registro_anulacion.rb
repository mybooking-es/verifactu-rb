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

        raise Verifactu::VerifactuError, "id_factura es obligatorio" if id_factura.nil?
        raise Verifactu::VerifactuError, "id_factura debe ser una instancia de IDFactura" unless id_factura.is_a?(Verifactu::IDFactura)

        if ref_externa
          raise Verifactu::VerifactuError, "ref_externa debe ser una String" unless Verifactu::Helper::Validador.cadena_valida?(ref_externa)
          raise Verifactu::VerifactuError, "ref_externa debe tener un maximo de 60 caracteres" if ref_externa.length > 60
        end

        if sin_registro_previo
          raise Verifactu::VerifactuError, "sin_registro_previo debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(sin_registro_previo.upcase)
        end

        if rechazo_previo
          raise Verifactu::VerifactuError, "rechazo_previo debe estar en #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(rechazo_previo.upcase)
        end

        if generado_por
          raise Verifactu::VerifactuError, "generado_por debe estar en #{Verifactu::Config::L16.join(', ')}" unless Verifactu::Config::L16.include?(generado_por.upcase)
          self.validar_generador(generador, generado_por)
        end

        # Validaciones de sistema_informatico
        raise Verifactu::VerifactuError, "sistema_informatico is required" if sistema_informatico.nil?
        raise Verifactu::VerifactuError, "sistema_informatico debe ser una instancia de SistemaInformatico" unless sistema_informatico.is_a?(SistemaInformatico)

        # Validaciones de fecha_hora_huso_gen_registro
        raise Verifactu::VerifactuError, "fecha_hora_huso_gen_registro is required" if fecha_hora_huso_gen_registro.nil?
        raise Verifactu::VerifactuError, "fecha_hora_huso_gen_registro debe estar en formato ISO 8601: YYYY-MM-DDThh:mm:ssTZD (ej: 2024-01-01T19:20:30+01:00)" unless Verifactu::Helper::Validador.fecha_hora_huso_gen_valida?(fecha_hora_huso_gen_registro)

        # Validaciones de tipo_huella
        raise Verifactu::VerifactuError, "tipo_huella is required" if tipo_huella.nil?
        raise Verifactu::VerifactuError, "tipo_huella debe estar entre #{Verifactu::Config::L12.join(', ')}" unless Verifactu::Config::L12.include?(tipo_huella.upcase)

        # Validaciones de huella
        raise Verifactu::VerifactuError, "huella is required" if huella.nil?
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
        raise Verifactu::VerifactuError, "generador debe ser una instancia de PersonaFisicaJuridica" unless generador.is_a?(PersonaFisicaJuridica)
        case generado_por.upcase
        when 'E'
          raise Verifactu::VerifactuError, "generador debe tener un NIF" if generador.nif.nil?
        when 'D'
          # La validacion que se pide aqui ya es una verificacion de IDOtro
        when 'T'
          raise Verifactu::VerifactuError, "generador debe estar censado" if generador.id_otro&.id_type == '07'
        end
      end
    end
  end
end
