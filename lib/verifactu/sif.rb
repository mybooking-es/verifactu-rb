module Verifactu
  #
  # It represents the SIF (Sistema de Información Fiscal) class in the Verifactu module.
  #
  class Sif
    attr_reader :nombre_razon, :nif, :nombre_sistema_informatico,
                :id_sistema_informatico, :version, :numero_instalacion,
                :tipo_uso_posible_solo_verifactu, :tipoUsoPosibleOtros, :tipoUsoPosibleMultiOT

    # Initializes a new instance of the Sif class.
    #
    # @param nombre_razon [String] The name or reason of the entity.
    # @param nif [String] The NIF (Número de Identificación Fiscal) of the entity.
    # @param nombre_sistema_informatico [String] The name of the information system.
    # @param id_sistema_informatico [String] The ID of the information system.
    # @param version [String] The version of the information system.
    # @param numero_instalacion [String] The installation number of the information system.
    # @param tipo_uso_posible_solo_verifactu [String] The possible use type for Verifactu only.
    # @param tipoUsoPosibleOtros [String] The possible use type for other systems.
    # @param tipoUsoPosibleMultiOT [String] The possible use type for multiple systems.
    #
    def initialize(nombre_razon:, nif:, nombre_sistema_informatico:, id_sistema_informatico:,
                   version:, numero_instalacion:,
                   tipo_uso_posible_solo_verifactu:, tipoUsoPosibleOtros:, tipoUsoPosibleMultiOT:)
      @nombre_razon = nombre_razon
      @nif = nif
      @nombre_sistema_informatico = nombre_sistema_informatico
      @id_sistema_informatico = id_sistema_informatico
      @version = version
      @numero_instalacion = numero_instalacion
      @tipo_uso_posible_solo_verifactu = tipo_uso_posible_solo_verifactu
      @tipoUsoPosibleOtros = tipoUsoPosibleOtros
      @tipoUsoPosibleMultiOT = tipoUsoPosibleMultiOT
    end
  end
end
