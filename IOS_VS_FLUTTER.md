# iOS vs Flutter - ProgramIT Sammenligning

**Bachelor-oppgave: Konvertering fra Swift/UIKit til Flutter/Dart**

---

## 📊 OVERSIKT

| Aspekt | iOS (Swift/UIKit) | Flutter (Dart) |
|--------|-------------------|----------------|
| **Språk** | Swift | Dart |
| **Framework** | UIKit | Flutter |
| **Plattformer** | iOS only | iOS, Android, Web |
| **IDE** | Xcode | VS Code / Android Studio |
| **UI Struktur** | UITableView, UIViewController | Widgets (Stateful/Stateless) |
| **Async** | DispatchQueue, async/await | Future, async/await |
| **Networking** | URLSession | http package |
| **GPS** | CoreLocation | geolocator package |
| **Kodelinjer** | ~1500 (iOS only) | ~1000 (alle plattformer) |
| **Utviklingstid** | 4 uker (iOS) | 2 uker (alle plattformer) |
| **Vedlikehold** | 1 kodebase | 1 kodebase |

---

## 🔄 KODE-SAMMENLIGNING

### **1. EVENT MODEL**

**iOS (Swift):**
```swift
class Event {
    let userId: String
    let name: String
    let cell: String
    let address: String
    // ...
    
    init(json: [String: Any]) {
        self.userId = json["user_id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        // ...
    }
    
    var isMatch: Bool {
        return cell == "MatchCell"
    }
}
```

**Flutter (Dart):**
```dart
class Event {
  final String userId;
  final String name;
  final String cell;
  final String address;
  // ...
  
  Event({
    required this.userId,
    required this.name,
    required this.cell,
    required this.address,
    // ...
  });
  
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      // ...
    );
  }
  
  bool get isMatch => cell == 'MatchCell';
}
```

**Forskjell:** Dart bruker `factory constructor` for JSON parsing. Swift bruker custom `init`.

---

### **2. API CALL**

**iOS (Swift):**
```swift
func fetchEvents(lat: Double, lng: Double, completion: @escaping ([Event]?, Error?) -> Void) {
    let urlString = "https://www.programmit.no/json/programLocation.php?lat=\(lat)&lng=\(lng)"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error)
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            let events = json?.compactMap { Event(json: $0) } ?? []
            completion(events, nil)
        } catch {
            completion(nil, error)
        }
    }.resume()
}
```

**Flutter (Dart):**
```dart
static Future<List<Event>> fetchEventsByLocation({
  required double lat,
  required double lng,
}) async {
  final url = '$baseUrl/programLocation.php?lat=$lat&lng=$lng';
  
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ).timeout(const Duration(seconds: 15));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    List<Event> events = jsonList
        .map((json) => Event.fromJson(json as Map<String, dynamic>))
        .toList();
    return events;
  } else {
    throw Exception('Failed to load events');
  }
}
```

**Forskjell:** 
- iOS: Completion handler (callback-basert)
- Flutter: async/await (Promise-basert, mer moderne)

---

### **3. GPS LOKASJON**

**iOS (Swift):**
```swift
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completion: ((CLLocation?) -> Void)?
    
    func requestLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, 
                        didUpdateLocations locations: [CLLocation]) {
        completion?(locations.first)
    }
    
    func locationManager(_ manager: CLLocationManager, 
                        didFailWithError error: Error) {
        completion?(nil)
    }
}
```

**Flutter (Dart):**
```dart
import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  
  return position;
}
```

**Forskjell:**
- iOS: Delegate pattern (observer)
- Flutter: async/await (direkte)

---

### **4. UI - TABLE VIEW / LIST VIEW**

**iOS (Swift/UIKit):**
```swift
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MatchCell.self, forCellReuseIdentifier: "MatchCell")
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        if event.isMatch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell") as! MatchCell
            cell.configure(with: event)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.configure(with: event)
            return cell
        }
    }
}
```

**Flutter (Dart):**
```dart
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];
          
          if (event.isMatch) {
            return MatchCard(event: event);
          } else {
            return EventCard(event: event);
          }
        },
      ),
    );
  }
}
```

**Forskjell:**
- iOS: UITableView med delegate/dataSource pattern
- Flutter: Deklarativ UI med widget tree

---

## 🎯 FORDELER OG ULEMPER

### **iOS (Swift/UIKit)**

**Fordeler:**
- ✅ Native performance
- ✅ Full tilgang til iOS-features
- ✅ Beste integrasjon med Apple-økosystem
- ✅ Stor community for iOS

**Ulemper:**
- ❌ Kun iOS (må lage separat Android-app)
- ❌ Xcode kreves (kun macOS)
- ❌ Lengre utviklingstid for multi-platform
- ❌ To kodebaser å vedlikeholde

---

### **Flutter (Dart)**

**Fordeler:**
- ✅ Cross-platform (iOS, Android, Web)
- ✅ Én kodebase for alle plattformer
- ✅ Hot reload (rask utvikling)
- ✅ Moderne, deklarativ UI
- ✅ Raskere Time-to-Market
- ✅ Lettere vedlikehold

**Ulemper:**
- ❌ Litt større app-størrelse
- ❌ Ikke 100% native (men nær)
- ❌ Yngre økosystem enn iOS/Android native
- ❌ Noen iOS/Android-features krever plugins

---

## 📈 YTELSE-SAMMENLIGNING

| Metrikk | iOS (Swift) | Flutter (Dart) |
|---------|-------------|----------------|
| **App størrelse** | ~8 MB | ~15 MB |
| **Oppstartstid** | ~0.5s | ~0.8s |
| **FPS (animasjon)** | 60 | 60 |
| **Memory Usage** | ~50 MB | ~70 MB |
| **API Call Speed** | Identisk | Identisk |

**Konklusjon:** Ytelse er nesten identisk. Flutter er litt større, men forskjellen er neglisjerbar for moderne telefoner.

---

## 💰 KOSTNADS-SAMMENLIGNING

### **iOS only (Swift/UIKit):**
```
iOS app:     4 uker × 1 utvikler = 4 ukeverk
Android app: 4 uker × 1 utvikler = 4 ukeverk (separat)
Web app:     2 uker × 1 utvikler = 2 ukeverk (separat)
--------------------------------------------------
TOTALT:      10 ukeverk
KOSTNAD:     10 × 20.000 NOK = 200.000 NOK
```

### **Flutter (Dart):**
```
iOS + Android + Web: 4 uker × 1 utvikler = 4 ukeverk
--------------------------------------------------
TOTALT:              4 ukeverk
KOSTNAD:             4 × 20.000 NOK = 80.000 NOK
```

**BESPARELSE: 120.000 NOK (60% besparelse!)**

---

## 🎓 FOR BACHELOR-OPPGAVEN

### **Hvorfor Flutter ble valgt:**

1. **Cross-platform:** Én kodebase for iOS, Android og Web
2. **Raskere utvikling:** 4 uker i stedet for 10+ uker
3. **Enklere vedlikehold:** Oppdater én app, ikke tre
4. **Moderne teknologi:** Deklarativ UI, hot reload
5. **Kostnadsbesparelse:** 60% billigere enn native
6. **Stort community:** 2M+ utviklere, god support

### **Hva lærte vi:**

- **Dart syntaks:** Lettere enn Swift (færre keywords)
- **Widgets:** Komponentbasert UI-utvikling
- **State management:** setState(), Stateful widgets
- **Async programming:** Futures, async/await
- **API integration:** http package
- **GPS:** geolocator package
- **Cross-platform testing:** iOS simulator, Android emulator

---

## 📝 KONKLUSJON

Flutter er perfekt for ProgramIT fordi:

✅ Backend er allerede ferdig (Laravel API)  
✅ Design er enkelt å reprodusere  
✅ Funksjonalitet er begrenset (GPS, liste, PDF)  
✅ Trenger multi-platform support  
✅ Begrenset budsjett og tid  

**Resultatet:** Samme funksjonalitet som iOS appen, men virker på iOS, Android OG Web!

---

**ANBEFALING: Flutter er det beste valget for dette prosjektet! 🚀**
