module Verifactu
    module Config
        # Listas de valores permitidos para los campos
        # Actualizado para version 1.0.9 del documento de validación de errores.
        # Se ha añadido el valor 20 y 21 a L8B: Operaciones sujetas al IPSI
        # (https://www.agenciatributaria.es/static_files/AEAT_Desarrolladores/EEDD/IVA/VERI-FACTU/DsRegistroVeriFactu.xlsx)

        # Impuesto
        L1 = ['01', # IVA
              '02', # ISPI Ceuta y Melilla,
              '03', # IGIC
              '05'] # Otros
        # Invoice type
        L2 = ['F1', # Factura
              'F2', # Factura simplificada
              'F3', # Invoice issued replacing simplified invoices that were invoiced and declared
              'R1', # Rectificativa (Art. 80.1 80.2 80.6)
              'R2', # Rectificativa (Art. 80.3)
              'R3', # Rectificativa (Art. 80.4)
              'R4', # Rectificativa (Resto)
              'R5'] # Rectification in simplified invoice
        # Rectification type
        L3 = ['S', # Por sustitución
              'I'] # Por diferencia
        L4 = ['S', 'N'] # Si/No
        L5 = ['S', 'N'] # Si/No
        L6 = ['D', # Destinatario
              'T'] # Tercero
        L7 = ['02', # NIF-IVA
              '03', # Pasaporte
              '04', # Documento de identidad extranjero
              '05', # Certificado de residencia
              '06', # Otro documento probatorio
              '07'] # No censado
        #DESCRIPCIÓN DE LA CLAVE DE RÉGIMEN PARA DESGLOSES DONDE EL IMPUESTO DE APLICACIÓN ES EL IVA
        L8A = ['01', # Operación de régimen general
               '02', # Exportación
               '03', # Operaciones a las que se aplique el régimen especial de bienes usados, objetos de arte, antigüedades y objetos de colección.
               '04', # Régimen especial del oro de inversión.
               '05',
               '06',
               '07',
               '08',
               '09',
               '10',
               '11',
               '12',
               '13',
               '14',
               '15',
               '16',
               '17',
               '18',
               '19',
               '20']
        L8B = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21'] #DESCRIPCIÓN DE LA CLAVE DE RÉGIMEN PARA DESGLOSES DONDE EL IMPUESTO DE APLICACIÓN ES EL IGIC
        # Calificación de operación
        L9 = ['S1', # Operación sujeta y no exenta - Sin inversión del sujeto pasivo
              'S2', # Operación sujeta y no exenta - Con inversión del sujeto pasivo
              'N1', # Operación no sujeta - Sin inversión del sujeto pasivo
              'N2'] # Operación no sujeta - Con inversión del sujeto pasivo
        L10 = ['E1', 'E2', 'E3', 'E4', 'E5', 'E6']
        L10B = ['E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8'] #DESCRIPCIÓN DEL MOTIVO EXENTA PARA DESGLOSES DONDE EL IMPUESTO DE APLICACIÓN ES EL IGIC
        L12 = ['01']
        L14 = ['S', 'N']
        L15 = ['1.0'] # Valores de versiones aceptadas de Verifactu
        L16 = ['E', 'D', 'T']
        L17 = ['N', 'S', 'X']
        L1E = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '90']
        L2E = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '90']
        L3E = ['S', 'N']
        L4E = ['D', 'T']

        L1C = ["S"] # Indicador representante
        L2C = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"] # Meses del año Periodo de imputación


        PAISES_PERMITIDOS = ['DE', 'AT', 'BE', 'CY', 'CZ', 'HR', 'DK', 'SK', 'SI', 'ES', 'EE', 'FI', 'FR', 'EL', 'GB', 'XI', 'NL', 'HU', 'IT', 'IE', 'LV', 'LT', 'LU', 'MT', 'PL', 'PT', 'SE', 'BG', 'RO']
        TIPO_IMPOSITIVO = ["0", "2", "4", "5", "7.5", "10", "21"]
        TIPO_RECARGO_EQUIVALENCIA = ["0", "0.26", "0.5", "0.62", "1", "1.4", "1.75", "5.2"]

        ID_VERSION = ENV['VERIFACTU_ID_VERSION'] || L15.first
        DESCRIPCION_OPERACION_DEFECTO = ENV["VERIFACTU_DESCRIPCION_OPERACION"] || "Factura Cliente"

        MAXIMO_FACTURA_SIMPLIFICADA = 3000.00
        MARGEN_ERROR_FACTURA_SIMPLIFICADA = 10.00
        MARGEN_ERROR_CUOTA_TOTAL = 10.00
        MARGEN_ERROR_IMPORTE_TOTAL = 10.00

    end
end
