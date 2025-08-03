require 'bigdecimal'

module Verifactu
  module RegistroFacturacion
    # It represents registro facturación alta at Verifactu.
    # Do not create instances of this class directly, use RegistroAltaBuilder instead
    # Representa <sum:RegistroAlta>
    class RegistroAlta
      attr_reader :id_version,
                  :id_factura,
                  :ref_externa,
                  :nombre_razon_emisor,
                  :subsanacion,
                  :rechazo_previo,
                  :tipo_factura,
                  :tipo_rectificativa,
                  :facturas_rectificativas,
                  :facturas_sustituidas,
                  :importe_rectificacion,
                  :fecha_operacion,
                  :descripcion_operacion,
                  :factura_simplificada_Art7273,
                  :factura_sin_identif_destinatario_art61d,
                  :macrodato,
                  :emitida_por_tercero_o_destinatario,
                  :tercero,
                  :destinatarios,
                  :cupon,
                  :desglose,
                  :cuota_total,
                  :importe_total,
                  :encadenamiento,
                  :sistema_informatico,
                  :fecha_hora_huso_gen_registro,
                  :num_registro_acuerdo_facturacion,
                  :id_acuerdo_sistema_informatico,
                  :tipo_huella,
                  :huella,
                  :signature

      def initialize(id_factura:,
                    ref_externa: nil,
                    nombre_razon_emisor:,
                    subsanacion: nil,
                    rechazo_previo: nil,
                    tipo_factura:,
                    tipo_rectificativa: nil,
                    facturas_rectificativas: nil,
                    facturas_sustituidas: nil,
                    importe_rectificacion: nil,
                    fecha_operacion: nil,
                    descripcion_operacion:,
                    factura_simplificada_Art7273: nil,
                    factura_sin_identif_destinatario_art61d: nil,
                    macrodato: nil,
                    emitida_por_tercero_o_destinatario: nil,
                    tercero: nil,
                    destinatarios: nil,
                    cupon: nil,
                    desglose:,
                    cuota_total: nil,
                    importe_total:,
                    encadenamiento: nil,
                    sistema_informatico:,
                    fecha_hora_huso_gen_registro:,
                    num_registro_acuerdo_facturacion: nil,
                    id_acuerdo_sistema_informatico: nil,
                    tipo_huella:,
                    huella:,
                    signature: nil)

        # Validaciones de id_factura
        raise ArgumentError, "id_factura is required" if id_factura.nil?
        raise ArgumentError, "id_factura must be an instance of IDFactura" unless id_factura.is_a?(IDFactura)

        # Validaciones de ref_externa
        unless ref_externa.nil?
          raise ArgumentError, "ref_externa debe ser una String" if !ref_externa.is_a?(String)
          raise ArgumentError, "ref_externa debe tener una longitud máxima de 60 caracteres" if ref_externa.length > 60
        end

        # Validaciones de nombre_razon_emisor
        raise ArgumentError, "nombre_razon_emisor is required" if nombre_razon_emisor.nil?
        raise ArgumentError, "nombre_razon_emisor debe ser una String" if !nombre_razon_emisor.is_a?(String)
        raise ArgumentError, "nombre_razon_emisor debe tener una longitud máxima de 120 caracteres" if nombre_razon_emisor.length > 120

        # Validaciones de subsanacion
        raise ArgumentError, "subsanacion debe ser estar entre #{Verifactu::Config::L4.join(', ')} o ser nil" unless subsanacion.nil? || Verifactu::Config::L4.include?(subsanacion.upcase)

        # Validaciones de rechazo_previo (ASIGNACION DE VARIABLE)
        if subsanacion == "S"
          raise ArgumentError, "rechazo_previo debe estar entre #{Verifactu::Config::L17.join(', ')}" unless rechazo_previo.nil? || Verifactu::Config::L14.include?(rechazo_previo.upcase)
          @rechazo_previo = rechazo_previo
        else
          @rechazo_previo = nil
        end

        # Validaciones de tipo_factura
        raise ArgumentError, "tipo_factura is required" if tipo_factura.nil?
        raise ArgumentError, "tipo_factura debe ser una String" if !tipo_factura.is_a?(String)
        raise ArgumentError, "tipo_factura debe ser uno de los siguientes valores: #{Verifactu::Config::L2.join(', ')}" unless Verifactu::Config::L2.include?(tipo_factura.upcase)

        # Validaciones de tipo_rectificativa
        if tipo_factura == "R1" || tipo_factura == "R2" || tipo_factura == "R3" || tipo_factura == "R4" || tipo_factura == "R5"
          raise ArgumentError, "tipo_rectificativa es obligatorio si tipo_factura es rectificativa" if tipo_rectificativa.nil?
          raise ArgumentError, "tipo_rectificativa debe ser una String" if !tipo_rectificativa.is_a?(String)
          raise ArgumentError, "tipo_rectificativa debe estar entre #{Verifactu::Config::L3.join(', ')}" unless Verifactu::Config::L3.include?(tipo_rectificativa.upcase)
        end

        # Validaciones de facturas_rectificativas y facturas_sustituidas (ASIGNACION DE VARIABLES)
        #TODO El NIF del campo IDEmisorFactura debe estar identificado.
        if tipo_factura == "R1" || tipo_factura == "R2" || tipo_factura == "R3" || tipo_factura == "R4" || tipo_factura == "R5"
          unless tipo_rectificativa.nil?
            raise ArgumentError, "facturas_rectificativas debe ser un Array" unless facturas_rectificativas.is_a?(Array)
            raise ArgumentError, "facturas_rectificativas no puede estar vacío" if facturas_rectificativas.empty?
            raise ArgumentError, "facturas_rectificativas no puede tener más de 1000 elementos" if facturas_rectificativas.size > 1000

            invalid_factura = facturas_rectificativas.find { |f| !f.is_a?(IDFactura) }
            raise ArgumentError, "Todos los elementos de facturas_rectificativas deben ser instancias de IDFactura" if invalid_factura
          end
          @facturas_rectificativas = facturas_rectificativas
          @facturas_sustituidas = nil
        elsif tipo_factura == "F3"
          unless tipo_rectificativa.nil?
            raise ArgumentError, "facturas_sustituidas debe ser un Array" unless facturas_sustituidas.is_a?(Array)
            raise ArgumentError, "facturas_sustituidas no puede estar vacío" if facturas_sustituidas.empty?
            raise ArgumentError, "facturas_sustituidas no puede tener más de 1000 elementos" if facturas_sustituidas.size > 1000

            invalid_factura = facturas_sustituidas.find { |f| !f.is_a?(IDFactura) }
            raise ArgumentError, "Todos los elementos de facturas_sustituidas deben ser instancias de IDFactura" if invalid_factura
          end
          @facturas_sustituidas = facturas_sustituidas
          @facturas_rectificativas = nil
        else
          @facturas_rectificativas = nil
          @facturas_sustituidas = nil
        end

        # Validaciones de importe_rectificacion (ASIGNACION DE VARIABLE)
        if tipo_rectificativa == 'S'
          raise ArgumentError, "importe_rectificacion es obligatorio si tipo_rectificativa es 'S'" if importe_rectificacion.nil?
          raise ArgumentError, "importe_rectificacion debe ser una instancia de ImporteRectificacion" unless importe_rectificacion.is_a?(ImporteRectificacion)
          @importe_rectificacion = importe_rectificacion
        else
          @importe_rectificacion = nil
        end

        # Validaciones de fecha_operacion
        if fecha_operacion
          current_date = Date.today
          min_date = current_date << (20 * 12) # Fecha actual menos 20 años
          max_date = current_date >> 12       # Fecha actual más 1 año

          raise ArgumentError, "fecha_operacion debe ser una instancia de Date" unless fecha_operacion.is_a?(Date)
          raise ArgumentError, "fecha_operacion no puede ser inferior a #{min_date}" if fecha_operacion < min_date
          raise ArgumentError, "fecha_operacion no puede ser superior a #{max_date}" if fecha_operacion > max_date

          if ["01", "03", nil].include?(impuesto) && !["14", "15"].include?(clave_regimen)
            raise ArgumentError, "fecha_operacion no puede ser superior a la fecha actual para Impuesto='01', '03' o no cumplimentado, salvo que ClaveRegimen sea '14' o '15'" if fecha_operacion > current_date
          end
        end

        # Validaciones de descripcion_operacion
        raise ArgumentError, "descripcion_operacion is required" if descripcion_operacion.nil?
        raise ArgumentError, "descripcion_operacion debe ser una String" unless descripcion_operacion.is_a?(String)
        raise ArgumentError, "descripcion_operacion debe tener una longitud máxima de 500 caracteres" if descripcion_operacion.length > 500

        # Validaciones de factura_simplificada_Art7273
        if factura_simplificada_Art7273
          raise ArgumentError, "factura_simplificada_Art7273 debe ser una String" unless factura_simplificada_Art7273.is_a?(String)
          raise ArgumentError, "factura_simplificada_Art7273 debe estar entre #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(factura_simplificada_Art7273.upcase)

          if factura_simplificada_Art7273 == "S"
            valid_tipo_factura = ["F1", "F3", "R1", "R2", "R3", "R4"]
            raise ArgumentError, "factura_simplificada_Art7273 sólo puede ser 'S' si TipoFactura es uno de los siguientes valores: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(tipo_factura)
          end
        end

        # Validaciones de factura_sin_identif_destinatario_art61d
        if factura_sin_identif_destinatario_art61d
          raise ArgumentError, "factura_sin_identif_destinatario_art61d debe ser una String" unless factura_sin_identif_destinatario_art61d.is_a?(String)
          raise ArgumentError, "factura_sin_identif_destinatario_art61d debe estar entre #{Verifactu::Config::L5.join(', ')}" unless Verifactu::Config::L5.include?(factura_sin_identif_destinatario_art61d.upcase)

          if factura_sin_identif_destinatario_art61d == "S"
            valid_tipo_factura = ["F2", "R5"]
            raise ArgumentError, "factura_sin_identif_destinatario_art61d sólo puede ser 'S' si TipoFactura es uno de los siguientes valores: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(tipo_factura)
          end
        end

        # Validaciones de macrodato
        if macrodato
          raise ArgumentError, "macrodato debe ser una String" unless macrodato.is_a?(String)
          raise ArgumentError, "macrodato debe estar entre #{Verifactu::Config::L14.join(', ')}" unless Verifactu::Config::L14.include?(macrodato.upcase)
        end

        # Validaciones de emitida_por_tercero_o_destinatario
        if emitida_por_tercero_o_destinatario
          raise ArgumentError, "emitida_por_tercero_o_destinatario debe ser una String" unless emitida_por_tercero_o_destinatario.is_a?(String)
          raise ArgumentError, "emitida_por_tercero_o_destinatario debe estar entre #{Verifactu::Config::L6.join(', ')}" unless Verifactu::Config::L6.include?(emitida_por_tercero_o_destinatario.upcase)
        end
        # Validaciones de tercero (ASIGNACION DE VARIABLE)
        if emitida_por_tercero_o_destinatario == "T"
          raise ArgumentError, "tercero is required" if tercero.nil?
          raise ArgumentError, "tercero debe ser una instancia de PersonaFisicaJuridica" unless tercero.is_a?(PersonaFisicaJuridica)

          raise ArgumentError, "tercero debe tener un NIF distindo al NIF del emisor de la factura" if tercero.nif == id_factura.id_emisor_factura
          raise ArgumentError, "tercero debe estar censado (id_type != 07)" if tercero.id_otro && tercero.id_otro.id_type == '07'
          @tercero = tercero
        else
          @tercero = nil
        end

        # Validaciones de destinatarios
        if ['F1', 'F3', 'R1', 'R2', 'R3', 'R4'].include?(tipo_factura)
          raise ArgumentError, "destinatarios is required" if destinatarios.nil?
          raise ArgumentError, "destinatarios debe ser una instancia de Destinatarios" unless destinatarios.is_a?(Array)
          raise ArgumentError, "destinatarios debe tener al menos un destinatario" if destinatarios.empty?
          destinatarios.each do |destinatario|
            raise ArgumentError, "Si el destinatario no esta censado, el codigo de pais debe ser español. Destinatario: #{destinatario.inspect}" if destinatario.id_otro && destinatario.id_otro.id_type == '07' && destinatario.id_otro.codigo_pais != 'ES'
          end
        elsif ['F2', 'R5'].include?(tipo_factura)
          raise ArgumentError, "destinatarios debe ser nil si TipoFactura es F2 o R5" unless destinatarios.nil?
        end

        # Validaciones de cupon
        raise ArgumentError, "cupon debe estar entre #{Verifactu::Config::L4.join(', ')} o ser nil" unless cupon.nil? || Verifactu::Config::L4.include?(cupon.upcase)
        if cupon == 'S'
          raise ArgumentError, "solo las facturas R5 y R1 pueden tener cupon" unless tipo_factura == 'R5' || tipo_factura == 'R1'
        end

        # Validaciones de desglose
        # Las validaciones de desglose que requieran valores de registro_alta se realizan aqui
        raise ArgumentError, "desglose is required" if desglose.nil?
        raise ArgumentError, "desglose debe ser una lista de instancias de Desglose" unless desglose.is_a?(Array)
        raise ArgumentError, "desglose no puede estar vacío" if desglose.empty?
        sum_base_imponible_cuota_repercutida = 0
        sum_cuota = 0
        sum_importe_desglose = 0
        desglose.each do |d|
          raise ArgumentError, "Cada elemento de desglose debe ser una instancia de Desglose" unless d.is_a?(DetalleDesglose)
          if d.impuesto == "01"
            fecha_factura = Date.parse(fecha_operacion || id_factura.fecha_expedicion_factura, "dd-mm-yyyy")
            case d.tipo_impositivo
            when "5"
              raise ArgumentError, "tipo_impositivo no puede ser 5 si la fecha de la factura no esta entre 1 de julio de 2022 y 30 de septiembre de 2024" unless fecha_factura.between?(Date.new(2022, 7, 1), Date.new(2024, 9, 30))
              if d.tipo_recargo_equivalencia == "0.5"
                raise ArgumentError, "tipo_recargo_equivalencia debe ser 0.5 si la fecha de la factura es menor o igual a 31 de diciembre de 2022" unless fecha_factura <= Date.new(2022, 12, 31)
              elsif d.tipo_recargo_equivalencia == "0.62"
                raise ArgumentError, "tipo_recargo_equivalencia debe ser 0.62 si la fecha de la factura esta entre 1 de enero de 2023 y 30 de septiembre de 2024" unless fecha_factura.between?(Date.new(2023, 1, 1), Date.new(2024, 9, 30))
              end
            when "2"
              raise ArgumentError, "tipo_impositivo no puede ser 2 si la fecha de la factura no esta entre 1 de octubre de 2024 y 31 de diciembre de 2024" unless fecha_factura.between?(Date.new(2024, 10, 1), Date.new(2024, 12, 31))
            when "7.5"
              raise ArgumentError, "tipo_impositivo no puede ser 7.5 si la fecha de la factura no esta entre 1 de octubre de 2024 y 31 de diciembre de 2024" unless fecha_factura.between?(Date.new(2024, 10, 1), Date.new(2024, 12, 31))
            when "0"
              if d.tipo_recargo_equivalencia == "0"
                raise ArgumentError, "tipo_recargo_equivalencia debe ser 0 si la fecha de la factura esta entre 1 de enero de 2023 y menor 30 de septiembre de 2024" unless fecha_factura.between?(Date.new(2023, 1, 1), Date.new(2024, 9, 30))
              end
            end
          end

          if d.calificacion_operacion == "S2"
            valid_tipo_factura = ["F1", "F3", "R1", "R2", "R3", "R4"]
            raise ArgumentError, "cuando calificacion_operacion es S2, tipo_factura debe ser uno de los siguientes valores: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(tipo_factura)
          end

          error_message = "cuando clave_regimen es #{d.clave_regimen}"
          case d.clave_regimen
          when "06"
            if d.impuesto == "01" || d.impuesto == "03"
              invalid_tipo_factura = ["F2", "F3", "R5"]
              raise ArgumentError, "#{error_message}, tipo_factura no puede ser uno de los siguientes valores: #{invalid_tipo_factura.join(', ')}" if invalid_tipo_factura.include?(tipo_factura)
            end
          when "10"
            valid_tipo_factura = ["F1"]
            raise ArgumentError, "#{error_message}, tipo_factura debe ser uno de los siguientes valores: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(tipo_factura)
            destinatarios.each do |destinatario|
              raise ArgumentError, "#{error_message}, todos los destinatarios deben tener un NIF" unless destinatario.nif
            end
          when "14"
            if d.impuesto == "01" || d.impuesto == "03"
              raise ArgumentError, "#{error_message}, fecha_operacion es obligatoria" if fecha_operacion.nil?
              raise ArgumentError, "#{error_message}, fecha_operacion debe posterior a fecha_expedicion_factura" if fecha_operacion < id_factura.fecha_expedicion_factura
            end
          end

          unless tipo_rectificativa == "I" || tipo_factura == "R2" || tipo_factura == "R3"
            d.validar_cuota_repercutida
          end

          sum_base_imponible_cuota_repercutida += d.base_imponible_o_importe_no_sujeto.to_f + d.cuota_repercutida.to_f
          sum_cuota += d.cuota_repercutida.to_f + d.cuota_recargo_equivalencia.to_f

          clave_regimen_exempta_importe_total = ['03', '05', '06', '08', '09']
          unless clave_regimen_exempta_importe_total.include?(d.clave_regimen)
            sum_importe_desglose += d.base_imponible_o_importe_no_sujeto.to_f + d.cuota_repercutida.to_f + d.cuota_recargo_equivalencia.to_f
          end
        end

        if tipo_factura == "F2"
          unless num_registro_acuerdo_facturacion || factura_sin_identif_destinatario_art61d == "S"
            raise ArgumentError, "La suma de base_imponible_o_importe_no_sujeto y cuota_repercutida de todos los desgloses debe ser inferior a #{Verifactu::Config::MAXIMO_FACTURA_SIMPLIFICADA+Verifactu::Config::MARGEN_ERROR_FACTURA_SIMPLIFICADA}" if sum_base_imponible_cuota_repercutida > Verifactu::Config::MAXIMO_FACTURA_SIMPLIFICADA + Verifactu::Config::MARGEN_ERROR_FACTURA_SIMPLIFICADA
          end
        end

        # Validaciones de cuota_total
        raise ArgumentError, "cuota_total is required" if cuota_total.nil?
        raise ArgumentError, "cuota_total debe tener maximo 12 digitos antes del decimal y 2 decimales" unless Verifactu::Helper::Validador.validar_digito(cuota_total, digitos: 12)
        diferencia_cuota_total = cuota_total.to_f - sum_cuota
        raise ArgumentError, "Cuota total no coincide con la suma de desgloses: #{cuota_total} - #{sum_cuota} = #{diferencia_cuota_total}" if diferencia_cuota_total.abs > Config::MARGEN_ERROR_CUOTA_TOTAL

        # Validaciones de importe_total
        raise ArgumentError, "importe_total is required" if importe_total.nil?
        raise ArgumentError, "importe_total debe tener maximo 12 digitos antes del decimal y 2 decimales" unless Verifactu::Helper::Validador.validar_digito(importe_total, digitos: 12)
        diferencia_importe_total = importe_total.to_f - sum_importe_desglose
        raise ArgumentError, "importe_total no coincide con la suma de desgloses: #{importe_total} - #{sum_importe_desglose} = #{diferencia_importe_total}" if diferencia_importe_total.abs > Config::MARGEN_ERROR_IMPORTE_TOTAL

        # Validaciones de sistema_informatico
        raise ArgumentError, "sistema_informatico is required" if sistema_informatico.nil?
        raise ArgumentError, "sistema_informatico debe ser una instancia de SistemaInformatico" unless sistema_informatico.is_a?(SistemaInformatico)

        # Validaciones de fecha_hora_huso_gen_registro
        raise ArgumentError, "fecha_hora_huso_gen_registro is required" if fecha_hora_huso_gen_registro.nil?
        unless fecha_hora_huso_gen_registro.is_a?(String) && fecha_hora_huso_gen_registro.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|[+-]\d{2}:\d{2})\z/)
          raise ArgumentError, "fecha_hora_huso_gen_registro debe estar en formato ISO 8601: YYYY-MM-DDThh:mm:ssTZD (ej: 2024-01-01T19:20:30+01:00)"
        end

        # Validaciones de num_registro_acuerdo_facturacion
        if num_registro_acuerdo_facturacion
          raise ArgumentError, "num_registro_acuerdo_facturacion debe ser una String" unless num_registro_acuerdo_facturacion.is_a?(String)
          raise ArgumentError, "num_registro_acuerdo_facturacion debe tener una longitud máxima de 15 caracteres" if num_registro_acuerdo_facturacion.length > 15
          # TODO verificar que exista en la AEAT
        end

        # Validaciones de id_acuerdo_sistema_informatico
        if id_acuerdo_sistema_informatico
          raise ArgumentError, "id_acuerdo_sistema_informatico debe ser una String" unless id_acuerdo_sistema_informatico.is_a?(String)
          raise ArgumentError, "id_acuerdo_sistema_informatico debe tener una longitud máxima de 16 caracteres" if id_acuerdo_sistema_informatico.length > 16
          # TODO verificar que exista en la AEAT
        end

        # Validaciones de encadenamiento
        raise ArgumentError, "encadenamiento es obligatorio" if encadenamiento.nil?
        raise ArgumentError, "encadenamiento debe ser una instancia de Encadenamiento" unless encadenamiento.is_a?(Encadenamiento)

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

        raise ArgumentError, "ID VERSION NO ES UNA VERSION ACEPTADA POR VERIFACTU" unless Verifactu::Config::L15.include?(Verifactu::Config::ID_VERSION)

        @id_version = Verifactu::Config::ID_VERSION
        @id_factura = id_factura # Instancia de IDFactura
        @ref_externa = ref_externa
        @nombre_razon_emisor = nombre_razon_emisor
        @subsanacion = subsanacion
        @rechazo_previo = rechazo_previo
        @tipo_factura = tipo_factura
        @tipo_rectificativa = tipo_rectificativa
        @facturas_rectificativas = facturas_rectificativas
        @facturas_sustituidas = facturas_sustituidas
        @importe_rectificacion = importe_rectificacion
        @fecha_operacion = fecha_operacion
        @descripcion_operacion = descripcion_operacion
        @factura_simplificada_Art7273 = factura_simplificada_Art7273
        @factura_sin_identif_destinatario_art61d = factura_sin_identif_destinatario_art61d
        @macrodato = macrodato
        @emitida_por_tercero_o_destinatario = emitida_por_tercero_o_destinatario
        @tercero = tercero # Instancia de PersonaFisicaJuridica
        @destinatarios = destinatarios # Array de instancias de Destinatario
        @cupon = cupon
        @desglose = desglose # Array de instancias de Desglose
        @cuota_total = cuota_total
        @importe_total = importe_total
        @encadenamiento = encadenamiento
        @sistema_informatico = sistema_informatico # Instancia de SistemaInformatico
        @fecha_hora_huso_gen_registro = fecha_hora_huso_gen_registro
        @num_registro_acuerdo_facturacion = num_registro_acuerdo_facturacion
        @id_acuerdo_sistema_informatico = id_acuerdo_sistema_informatico
        @tipo_huella = tipo_huella
        @huella = huella
        @signature = signature

        if BigDecimal(importe_total).abs > 100_000_000.00
          @macrodato = 'S'
        end
      end
    end
  end
end
