import Foundation

/// License-plate type. The ordinal is `data.PlateType`; `36` is `privateVehicle`.
///
/// Display strings are in EventL10n, copied from VMS `StringResources` (`EPlateType_*`).
public enum PlateType: Int, CaseIterable, Hashable, Sendable {
    case agricultural = 0
    case ambulance
    case atv
    case bicycle
    case busPublicTransport
    case civilDefenseForces
    case classicalHistorical
    case classicalMotorcycle
    case commercial
    case consular
    case dealer
    case diplomatic
    case diplomaticHeadsCar
    case diplomaticMotorcycle
    case electricCar
    case exporting
    case fireServices
    case foreigner
    case funeral
    case governmental
    case handicapped
    case imported
    case internationalOrganisation
    case justicePolice
    case leased
    case legalEntity
    case localAuthority
    case military
    case militaryMotorcycle
    case militaryTrailerSemitrailer
    case militaryWorkVehicle
    case moped
    case police
    case policeMotorcycle
    case policeTrailerSemitrailer
    case privateMotorcycle
    case privateVehicle
    case railwayServices
    case redCross
    case rentalVehicle
    case royal
    case scooter
    case slowVehicle
    case smallVehicle
    case snowmobileAllTerrainVehicle
    case sportsCarTruck
    case sportsMotocycle
    case taxFree
    case taxi
    case technological
    case temporary
    case temporaryMilitary
    case temporaryMotorcycle
    case temporaryWorkVehicle
    case testDrive
    case trailerSemitrailer
    case transportingGoods
    case trucks
    case unitedNations
    case unknownPlateType
    case van
    case workVehicle
}
