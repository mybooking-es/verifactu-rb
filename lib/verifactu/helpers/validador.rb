require 'date'

module Verifactu
  module Helper
    class Validador
      # Validar el formato del NIF.
      # @param nif [String] NIF a validar
      # @raise [Verifactu::VerifactuError] Si el NIF es nil, vacío o no es una cadena
      def self.validar_nif(nif)
        raise Verifactu::VerifactuError, "NIF cannot be nil or empty" if nif.nil? || nif.empty?
        raise Verifactu::VerifactuError, "NIF must be a string" unless nif.is_a?(String)
        #TODO implementar validación de NIF via API de AEAT
      end

      # El dia de hoy, en la zona horaria de la aplicacion anfitriona si la hay.
      #
      # `Time.zone` lo aporta ActiveSupport, que la gem NO declara como dependencia:
      # la trae (o no) quien la usa. Sin ActiveSupport el metodo no existe, asi que
      # el `if Time.zone` que habia aqui levantaba NoMethodError en vez de caer al
      # `Date.today` de al lado — la gem no se podia usar fuera de una app Rails-like
      # y su propia suite de tests no pasaba.
      #
      # @return [Date]
      def self.hoy
        if Time.respond_to?(:zone) && Time.zone
          Time.zone.today
        else
          Date.today
        end
      end

      # Validar si la fecha es válida y no está en el futuro.
      # @param fecha [String, Date] Fecha a validar
      # @raise [Verifactu::VerifactuError] Si la fecha es nil, no es un objeto Date o una cadena de fecha válida
      def self.validar_fecha_pasada(fecha)
        fecha_d = self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Fecha no puede estar en el futuro" if fecha_d > self.hoy
      end

      # Validar si la fecha es válida y no está en el pasado.
      # @param fecha [String, Date] Fecha a validar
      # @raise [Verifactu::VerifactuError] Si la fecha es nil, no es un objeto Date o una cadena de fecha válida
      def self.validar_fecha_futura(fecha)
        fecha_d = self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Fecha no puede estar en el pasado" if fecha_d < self.hoy
      end

      # Validar si la fecha es válida y es el último día del año.
      # @param fecha [String, Date] Fecha a validar
      # @raise [Verifactu::VerifactuError] Si la fecha es nil, no es un objeto Date o una cadena de fecha válida
      def self.validar_fecha_fin_de_ano(fecha)
        fecha_d = self.validar_fecha(fecha)

        aeat_year = self.hoy.year
        valid_years = [aeat_year, aeat_year - 1]
        raise Verifactu::VerifactuError, "El año de la fecha debe ser igual al año actual o al año anterior" unless valid_years.include?(fecha_d.year)
        raise Verifactu::VerifactuError, "Fecha debe tener el formato 31-12-20XX" unless fecha_d == Date.new(fecha_d.year, 12, 31)
      end

      # Validar si la fecha es válida
      # @param fecha [String, Date] Fecha a validar
      # @raise [Verifactu::VerifactuError] Si la fecha es nil, no es un objeto Date
      def self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Fecha no puede ser nil" if fecha.nil?
        if fecha.is_a?(String)
          begin
            fecha_d = Date.parse(fecha, '%d-%m-%Y')
          rescue Verifactu::VerifactuError
            raise Verifactu::VerifactuError, "Formato de fecha inválido. Debe ser 'dd-mm-aaaa'."
          end
        elsif !fecha.is_a?(Date)
          raise Verifactu::VerifactuError, "Fecha debe ser una cadena de fecha"
        end
        fecha_d
      end

      # Validar si la fecha es válida (versión que retorna true/false)
      # @param fecha [String, Date] Fecha a validar
      # @return [Boolean] true si la fecha es válida, false en caso contrario
      def self.fecha_valida?(fecha)
        validar_fecha(fecha)
        true
      rescue Verifactu::VerifactuError
        false
      end

      # Validar si el digito es un número válido
      # @note Esta funcion se ha extraido para facilitar el mantenimiento y reutilización
      # @note De esta forma, se puede cambiar globalmente el separador de decimales o el formato de validación sin afectar a todas las clases que lo utilizan
      # @param digito [String] Dígito a validar
      # @param max_length [Integer] Longitud máxima del dígito
      # @raise [Verifactu::VerifactuError] Si el dígito es nil, no es una cadena o no cumple con el formato
      def self.validar_digito(digito, digitos: 12)
        raise Verifactu::VerifactuError, "Dígito no puede ser nil" if digito.nil?
        raise Verifactu::VerifactuError, "Dígito debe ser una cadena" unless digito.is_a?(String)
        return true if digito =~ /^-?\d{1,#{digitos}}(\.\d{0,2})?$/
        false
      end

      # Validar si la cadena contiene solo caracteres ASCII imprimibles
      # @param cadena [String] Cadena a validar
      # @raise [Verifactu::VerifactuError] Si la cadena es nil, no es una cadena o contiene caracteres no imprimibles
      # @note Se excluyen los caracteres '<', '>' y '=' desde 09/09/2025 (se vuelven a permitir desde 23/10/2025)
      #
      # Acepta Unicode imprimible, NO solo ASCII. Los tipos de texto del XSD de AEAT
      # (TextMax120Type y familia) son `restriction base="string"` con unicamente
      # `maxLength`: ni patron ni restriccion de juego de caracteres. Exigir
      # `ascii_only?` rechazaba nombres espanoles perfectamente validos que la AEAT
      # acepta sin problema — 'Compania Munoz S.L.', 'Jose Penniscola', 'Autos Innigo' —
      # y en la aplicacion eso se traducia en dejar la factura sin enviar.
      #
      # Lo que si se rechaza son los caracteres de control (Cc), que romperian el XML.
      def self.cadena_valida(cadena)
        raise Verifactu::VerifactuError, "Cadena no puede ser nil" if cadena.nil?
        raise Verifactu::VerifactuError, "Cadena debe ser una cadena" unless cadena.is_a?(String)
        raise Verifactu::VerifactuError, "Cadena debe estar codificada en UTF-8 valido" unless cadena.valid_encoding?
        raise Verifactu::VerifactuError, "Cadena no puede contener caracteres de control" if cadena.match?(/\p{Cc}/)
        # Descomentar la siguiente linea para volver a excluir los caracteres '<', '>' y '='
        # raise Verifactu::VerifactuError, "Cadena no puede contener los caracteres '<', '>' o '='" if cadena.include?('<') || cadena.include?('>') || cadena.include?('=')
      end

      # Validar si la cadena es válida (versión que retorna true/false)
      # @param cadena [String] Cadena a validar
      # @return [Boolean] true si la cadena es válida, false en caso contrario
      # @note Se excluyen los caracteres '<', '>' y '=' desde 09/09/2025 (se vuelven a permitir desde 23/10/2025)
      def self.cadena_valida?(cadena)
        cadena_valida(cadena)
        true
      rescue Verifactu::VerifactuError
        false
      end

      # Validar si la fecha y hora con huso horario está en formato ISO 8601
      # @param fecha_hora_huso_gen [String] Fecha y hora con huso horario a validar
      # @return [Boolean] true si la fecha y hora con huso horario está en formato ISO 8601, false en caso contrario
      def self.fecha_hora_huso_gen_valida?(fecha_hora_huso_gen)
        return false if fecha_hora_huso_gen.nil?
        return false unless fecha_hora_huso_gen.is_a?(String)
        return false unless fecha_hora_huso_gen.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|[+-]\d{2}:\d{2})\z/)
        true
      end
    end
  end
end
