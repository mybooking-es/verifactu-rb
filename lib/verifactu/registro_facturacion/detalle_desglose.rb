module Verifactu
  module RegistroFacturacion
    # Representa <sum1:DetalleDesglose>
    class DetalleDesglose

      private_class_method :new

      attr_reader :impuesto,
                  :clave_regimen,
                  :calificacion_operacion,
                  :operacion_exenta,
                  :tipo_impositivo,
                  :base_imponible_o_importe_no_sujeto,
                  :base_imponible_a_coste,
                  :cuota_repercutida,
                  :tipo_recargo_equivalencia,
                  :cuota_recargo_equivalencia

      #
      # Crea una instancia de DetalleDesglose de una operación no exenta de impuesto
      #
      # @param [String] impuesto Código del impuesto (L1)
      # @param [String] clave_regimen Clave del régimen (L8A o L8B)
      # @param [String] calificacion_operacion Calificación de la operación (L9)
      # @param [String] tipo_impositivo Tipo impositivo (L16)
      # @param [String] base_imponible_o_importe_no_sujeto Base imponible o importe no sujeto
      # @param [String] base_imponible_a_coste Base imponible a coste (opcional, solo si clave_regimen es '06' o impuesto es '02' o '05')
      # @param [String] cuota_repercutida Cuota repercutida (opcional, no debe estar presente si calificacion_operacion es 'N1' o 'N2')
      # @param [String] tipo_recargo_equivalencia Tipo de recargo de equivalencia (opcional, no debe estar presente si calificacion_operacion es 'N1' o 'N2')
      # @param [String] cuota_recargo_equivalencia Cuota de recargo de equivalencia (opcional, no debe estar presente si calificacion_operacion es 'N1' o 'N2')
      # @return [DetalleDesglose] Instancia de DetalleDesglose
      #
      def self.create_operacion(impuesto:, clave_regimen:, calificacion_operacion: , tipo_impositivo: ,
                                base_imponible_o_importe_no_sujeto:, base_imponible_a_coste: nil, cuota_repercutida: nil,
                                tipo_recargo_equivalencia: nil, cuota_recargo_equivalencia: nil)

        # Validar operacion
        validar_operacion(impuesto: impuesto, clave_regimen: clave_regimen,
                          calificacion_operacion: calificacion_operacion,
                          tipo_impositivo: tipo_impositivo, tipo_recargo_equivalencia: tipo_recargo_equivalencia,
                          cuota_recargo_equivalencia: cuota_recargo_equivalencia, cuota_repercutida: cuota_repercutida)

        # Validar calificacion operacion
        validar_calificacion_operacion(calificacion_operacion: calificacion_operacion,
                                      tipo_impositivo: tipo_impositivo,
                                      cuota_repercutida: cuota_repercutida)

        # Validar clave regimen
        validar_clave_regimen(clave_regimen: clave_regimen,
                              impuesto: impuesto,
                              tipo_impositivo: tipo_impositivo,
                              calificacion_operacion: calificacion_operacion,
                              base_imponible_a_coste: base_imponible_a_coste)

        detalle = new(impuesto: impuesto,
                      clave_regimen: clave_regimen,
                      calificacion_operacion: calificacion_operacion,
                      base_imponible_o_importe_no_sujeto: base_imponible_o_importe_no_sujeto,
                      base_imponible_a_coste: base_imponible_a_coste)

        detalle.instance_variable_set(:@tipo_impositivo, tipo_impositivo)
        detalle.instance_variable_set(:@cuota_repercutida, cuota_repercutida)
        detalle.instance_variable_set(:@tipo_recargo_equivalencia, tipo_recargo_equivalencia)
        detalle.instance_variable_set(:@cuota_recargo_equivalencia, cuota_recargo_equivalencia)

        return detalle

      end

      #
      # Crea una instancia de DetalleDesglose de una operación exenta de impuesto
      # @param [String] impuesto Código del impuesto (L1)
      # @param [String] clave_regimen Clave del régimen (L8A o L8B)
      # @param [String] calificacion_operacion Calificación de la operación (L9)
      # @param [String] operacion_exenta Motivo de la exención (L10A o L10B)
      # @param [String] base_imponible_o_importe_no_sujeto Base imponible o importe no sujeto
      # @param [String] base_imponible_a_coste Base imponible a coste (opcional, solo si clave_regimen es '06' o impuesto es '02' o '05')
      # @return [DetalleDesglose] Instancia de DetalleDesglose
      #
      def self.create_operacion_exenta(impuesto:, clave_regimen:, calificacion_operacion: , operacion_exenta:,
                                      base_imponible_o_importe_no_sujeto:, base_imponible_a_coste:)

        raise ArgumentError, "DetalleDesglose - se necesita operacion_exenta" if operacion_exenta.nil?

        # Validar operacion exenta
        validar_operacion_exenta(impuesto: impuesto,
                                operacion_exenta: operacion_exenta)

        # Validar clave regimen
        validar_clave_regimen(clave_regimen: clave_regimen,
                              impuesto: impuesto,
                              operacion_exenta: operacion_exenta,
                              calificacion_operacion: calificacion_operacion,
                              base_imponible_a_coste: base_imponible_a_coste)

        detalle = new(impuesto: impuesto,
                      clave_regimen: clave_regimen,
                      calificacion_operacion: calificacion_operacion,
                      base_imponible_o_importe_no_sujeto: base_imponible_o_importe_no_sujeto,
                      base_imponible_a_coste: base_imponible_a_coste)

        detalle.instance_variable_set(:@operacion_exenta, operacion_exenta)

        return detalle

      end

      # Validación de cuota repercutida que debe hacerse excepto si TipoRectificativa = “I” o TipoFactura “R2”, “R3”
      def validar_cuota_repercutida

        if @cuota_repercutida.to_f * @base_imponible_o_importe_no_sujeto.to_f < 0
          return false
        end

        resultado = @base_imponible_o_importe_no_sujeto.to_f * @tipo_impositivo.to_f / 100.0
        # Tolerancia de +/- 10 euros
        ((@cuota_repercutida.to_f - resultado).abs <= 10.0)
      end

      private

      #
      # TODO Separar en dos constructores, uno para operaciones y otro para exentas
      #
      def initialize(impuesto:, clave_regimen:, calificacion_operacion:,
                    base_imponible_o_importe_no_sujeto:, base_imponible_a_coste:)

        # Valida impuesto
        raise ArgumentError, "DetalleDesglose - impuesto obligatorio" unless impuesto
        unless Verifactu::Config::L1.include?(impuesto)
          raise ArgumentError, "DetalleDesglose - impuesto debe ser una de #{Verifactu::Config::L1.join(', ')}"
        end

        # Valida clave_regimen
        raise ArgumentError, "DetalleDesglose - calificacion_operacion obligatoria" if calificacion_operacion.nil?
        unless calificacion_operacion.nil? || Verifactu::Config::L9.include?(calificacion_operacion)
          raise ArgumentError, "DetalleDesglose - calificacion_operacion debe ser #{Verifactu::Config::L9.join(', ')}"
        end

        # Valida base_imponible_o_importe_no_sujeto
        unless base_imponible_o_importe_no_sujeto
          raise ArgumentError, "DetalleDesglose - base_imponible_o_importe_no_sujeto obligatorio"
        end
        unless Verifactu::Helper::Validador.validar_digito(base_imponible_o_importe_no_sujeto, digitos: 12)
          raise ArgumentError, "DetalleDesglose - base_imponible_o_importe_no_sujeto debe ser un número de maximo "\
                              "12 digitos antes del decimal y 2 decimales"
        end

        # Valida base_imponible_a_coste si está presente
        if base_imponible_a_coste
          unless clave_regimen == "06" || impuesto == "02" || impuesto == "05"
              raise ArgumentError, "DetalleDesglose - BaseImponibleACoste solo puede estar cumplimentado si "\
                                  "ClaveRegimen es '06' o Impuesto es '02' (IPSI) o '05' (Otros)"
          end
          unless Verifactu::Helper::Validador.validar_digito(base_imponible_a_coste, digitos: 12)
            raise ArgumentError, "DetalleDesglose - BaseImponibleACoste debe ser un número de maximo 12 digitos "\
                                "antes del decimal y 2 decimales"
          end
        end

        @impuesto = impuesto
        @clave_regimen = clave_regimen
        @calificacion_operacion = calificacion_operacion
        @base_imponible_o_importe_no_sujeto = base_imponible_o_importe_no_sujeto
        @base_imponible_a_coste = base_imponible_a_coste
      end

      #
      # Validar la operación
      #
      def self.validar_operacion(impuesto:, clave_regimen:, calificacion_operacion: , tipo_impositivo:, tipo_recargo_equivalencia:, cuota_recargo_equivalencia:, cuota_repercutida:)

        # Verifica que el tipo_impositivo es válido
        unless Verifactu::Helper::Validador.validar_digito(tipo_impositivo, digitos: 3)
          raise ArgumentError, "DetalleDesglose - tipo_impositivo debe ser menor a 999.99"
        end

        if impuesto == "01" # IVA
          unless Verifactu::Config::L8A.include?(clave_regimen)
            raise ArgumentError, "DetalleDesglose - IVA - clave_regimen debe ser #{Verifactu::Config::L8A.join(', ')}"
          end
          if calificacion_operacion == "S1"
            unless Verifactu::Config::TIPO_IMPOSITIVO.include?(tipo_impositivo)
              raise ArgumentError, "DetalleDesglose - IVA - S1 - tipo_impositivo debe ser un porcentaje válido "\
                                  "#{Verifactu::Config::TIPO_IMPOSITIVO.join(', ')}"
            end
            # Validar recarga equivalencia
            if tipo_recargo_equivalencia
              unless Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA.include?(tipo_recargo_equivalencia)
                raise ArgumentError, "DetalleDesglose - IVA - S1 - tipo_recargo_equivalencia debe ser uno de "\
                                    "#{Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA.join(', ')}"
              end
              # La validacion de tipo impositivo por fecha se realiza en el validador de factura
              unless tipo_recargo_equivalencia == "0"
                self.validar_tipo_recargo_equivalencia(tipo_recargo_equivalencia: tipo_recargo_equivalencia,
                                                      tipo_impositivo: tipo_impositivo)
              end
            end
          elsif calificacion_operacion == "N1" || calificacion_operacion == "N2"
            unless tipo_impositivo.nil?
              raise ArgumentError, "DetalleDesglose - IVA - N1|N2 - tipo_impositivo debe ser nil"
            end
            unless cuota_repercutida.nil?
              raise ArgumentError, "DetalleDesglose - IVA - N1|N2 - cuota_repercutida debe ser nil"
            end
            unless tipo_recargo_equivalencia.nil?
              raise ArgumentError, "DetalleDesglose - IVA - N1|N2 - tipo_recargo_equivalencia debe ser nil"
            end
            unless cuota_recargo_equivalencia.nil?
              raise ArgumentError, "DetalleDesglose - IVA - N1|N2 - cuota_recargo_equivalencia debe ser nil"
            end
          end
        elsif impuesto == "03" # IGIC
          unless Verifactu::Config::L8B.include?(clave_regimen)
            raise ArgumentError, "DetalleDesglose - IGIC - clave_regimen debe ser #{Verifactu::Config::L8B.join(', ')}"
          end
        end

      end

      def self.validar_operacion_exenta(impuesto:, operacion_exenta:)
        if impuesto == "01" # IVA
          unless Verifactu::Config::L10.include?(operacion_exenta)
            raise ArgumentError, "DetalleDesglose - operacion_exenta debe ser #{Verifactu::Config::L10.join(', ')}"
          end
        elsif impuesto == "03" # IGIC
          unless Verifactu::Config::L10B.include?(operacion_exenta)
            raise ArgumentError, "DetalleDesglose - operacion_exenta debe ser #{Verifactu::Config::L10B.join(', ')}"
          end
        end
      end

      # Valida en función de la calificación de operación
      def self.validar_calificacion_operacion(calificacion_operacion:, tipo_impositivo:, cuota_repercutida:)
        if calificacion_operacion == "S2"
          # La validacion de tipo_factura se realiza en el validador de factura
          unless tipo_impositivo == "0"
            raise ArgumentError, "DetalleDesglose - calificacionOperacion S2 - tipo_impositivo debe ser 0"
          end
          unless cuota_repercutida == "0"
            raise ArgumentError, "DetalleDesglose - calificacionOperacion S2 - cuota_repercutida debe ser 0"
          end
        elsif calificacion_operacion == "S1"
          unless tipo_impositivo
            raise ArgumentError, "DetalleDesglose - calificacionOperacion S1 - tipo_impositivo es obligatorio"
          end
          # Validacion de cuota_repercutida se ejecuta en el validador de factura
        end
      end


      # Valida en función de la clave de régimen
      def self.validar_clave_regimen(clave_regimen:, impuesto:, tipo_impositivo: nil, operacion_exenta: nil, calificacion_operacion:, base_imponible_a_coste:)
        # Validaciones adicionales para clave_regimen
        case clave_regimen
        when "02" # Exportación
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            unless operacion_exenta
              raise ArgumentError, "DetalleDesglose - claveRegimen 02 - OperacionExenta obligatoria"
            end
          end
        when "03" # REBU
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            unless calificacion_operacion.nil? || calificacion_operacion == "S1"
              # Calificacion operacion debe ser S1 o nil
              raise ArgumentError, "DetalleDesglose - claveRegimen 03 - CalificacionOperacion debe ser S1 o nil"
            end
          end
        when "04" #  Operaciones con oro de inversión
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            unless calificacion_operacion.nil? || calificacion_operacion == "S2"
              raise ArgumentError, "DetalleDesglose - claveRegimen 04 - CalificacionOperacion debe ser S2 o nil"
            end
          end
        when "06" # Grupo de entidades nivel avanzado
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            if base_imponible_a_coste.nil?
              raise ArgumentError, "DetalleDesglose - claveRegimen 06 - BaseImponibleACoste no debe ser nil"
            end
            # Validacion de tipoFactura se realiza en el validador de factura
          end
        when "07" # Criterio de caja.
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            if calificacion_operacion
              invalid_calificaciones = ["S2", "N1", "N2"]
              if invalid_calificaciones.include?(calificacion_operacion)
                raise ArgumentError, "DetalleDesglose - claveRegimen 07 - CalificacionOperacion no puede ser "\
                                    "#{invalid_calificaciones.join(', ')}"
              end
            elsif operacion_exenta
              invalid_operaciones_exentas = ["E2", "E3", "E4", "E5"]
              if invalid_operaciones_exentas.include?(operacion_exenta)
                raise ArgumentError, "DetalleDesglose - claveRegimen 07 - OperacionExenta no puede ser "\
                                    "#{invalid_operaciones_exentas.join(', ')}"
              end
            end
          end
        when "08"
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            valid_calificaciones = ["N2"]
            unless valid_calificaciones.include?(calificacion_operacion)
              raise ArgumentError, "DetalleDesglose - claveRegimen 08 - CalificacionOperacion debe ser "\
                                  "#{valid_calificaciones.join(', ')}"
            end
          end
        when "10" #Cobro por cuenta de terceros
          if impuesto == "01" || impuesto == "03" # IVA o IGIC
            valid_calificaciones = ["N1"]
            unless valid_calificaciones.include?(calificacion_operacion)
              raise ArgumentError, "DetalleDesglose - claveRegimen 10 - CalificacionOperacion debe ser "\
                                  "#{valid_calificaciones.join(', ')}"
            end
            # Validacion de tipoFactura se realiza en el validador de factura
            # Validacion de destinatario se realiza en el validador de factura
          end
        when "11" # Arrendamiento de local de negocio
          if impuesto == "01" # IVA
            valid_tipo_impositivo = ["21"]
            unless valid_tipo_impositivo.include?(tipo_impositivo)
              raise ArgumentError, "DetalleDesglose - claveRegimen 11 - IVA - TipoImpositivo debe ser "\
                                  "#{valid_tipo_impositivo.join(', ')}"
            end
          end
        # when "14" # IVA pendiente AAPP.
          # Validacion de fechaOperacion se realiza en el validador de factura
          # Validacion de destinatario se realiza en el validador de factura
          # Validacion de tipoFactura se realiza en el validador de factura
        end
      end

      # Validación de tipo recargo equivalencia - Asume que impuesto es IVA y calificacion_operacion es S1
      def self.validar_tipo_recargo_equivalencia(tipo_recargo_equivalencia:, tipo_impositivo:)
        case tipo_impositivo
        when "21"
          valid_impuestos = ["5.2", "1.75"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "10"
          valid_impuestos = ["1.4"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "7.5"
          valid_impuestos = ["1"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "5"
          valid_impuestos = ["0.5", "0.62"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "4"
          valid_impuestos = ["0.5"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "2"
          valid_impuestos = ["0.26"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        when "0"
          valid_impuestos = Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise ArgumentError, "DetalleDesglose - recargo equivalencia debe ser #{valid_impuestos.join(', ')}"
          end
        end
      end


    end
  end
end
