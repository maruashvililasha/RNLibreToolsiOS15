import Combine

public class RNLibreToolsiOS : RnLibreToolsProtocol {
   
    public private(set) var text = "Hello, World!"

    public static var shared : RnLibreToolsProtocol = RNLibreToolsiOS()
    private var nfc: NFC?
    
    var sessionCompletion : ((Result<Double, LibreError>) -> Void)?
    var activateCompletion : ((Result<Bool, LibreError>) -> Void)?
    
    private init() {
    }
    
    var history = History()
    
    public func activate(completion: @escaping (Result<Bool, LibreError>) -> Void) {
        self.activateCompletion = completion
        completion(.failure(LibreError(errorCode: 0, errorMessage: "Activation Not Yet Implemented")))
    }
    
    public func startSession(completion: @escaping (Result<Double, LibreError>) -> Void) {
        self.sessionCompletion = completion
        nfc = NFC()
        nfc?.main = self
        nfc?.startSession()
    }
    
    func parseSensorData(_ sensor: Sensor) {
        sensor.detailFRAM()
        if sensor.history.count > 0 && sensor.fram.count >= 344 {

            let _ = sensor.calibrationInfo
            
            history.rawTrend = sensor.trend
            
            let factoryTrend = sensor.factoryTrend
            history.factoryTrend = factoryTrend
            history.rawValues = sensor.history
            let factoryHistory = sensor.factoryHistory
            history.factoryValues = factoryHistory
        }
        didParseSensor(sensor)
    }


    func applyCalibration(sensor: Sensor?) {

        history.calibratedTrend = []
        history.calibratedValues = []

    }


    func didParseSensor(_ sensor: Sensor?) {
        
        applyCalibration(sensor: sensor)

        guard let sensor = sensor else {
            return
        }
        guard history.factoryTrend.count > 0 else { return }
        let currentGlucose = history.factoryTrend[0].value
        let calculatedGlucose = ((Double(currentGlucose) / 18.0182) * 10).rounded() / 10
        sessionCompletion?(.success(calculatedGlucose))

        if history.values.count > 0 || history.factoryValues.count > 0 {
            var entries = [Glucose]()
            if history.values.count > 0 {
                entries += self.history.values
            } else {
                entries += self.history.factoryValues
            }
            entries += history.factoryTrend.dropFirst() + [Glucose(currentGlucose, date: sensor.lastReadingDate)]
            entries = entries.filter{ $0.value > 0 && $0.id > -1 }
        }
    }
}

@available(iOS 13.0, *)
class History: ObservableObject {
    @Published var values:        [Glucose] = []
    @Published var rawValues:     [Glucose] = []
    @Published var rawTrend:      [Glucose] = []
    @Published var factoryValues: [Glucose] = []
    @Published var factoryTrend:  [Glucose] = []
    @Published var calibratedValues: [Glucose] = []
    @Published var calibratedTrend:  [Glucose] = []
    @Published var storedValues:     [Glucose] = []
    @Published var nightscoutValues: [Glucose] = []
}
