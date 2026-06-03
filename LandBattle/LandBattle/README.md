//
//  README.md
//  LandBattle
//
//  Created by Dev Mistry on 4/17/26.
//

### Land Battle – Prototype (Testing Instructions)

feature for prototype submission: location based territory capture

### How to Test

1. Run the app in the iOS Simulator.
                
2. Allow location access when prompted.
                
3. In the Simulator menu, go to:
        Features -> Location -> Custom Location
                
4. Enter coordinates near one of the sample territories:

   - Old Main: `40.7982, -77.8599`
   - HUB Lawn: `40.8018, -77.8615`
   - Westgate: `40.7999, -77.8677`

- Your location will move to the selected area.
- The territory will change from Unclaimed to Dev
- Capture Message will Appear
- It is now captured.

### Notes

- Territories and a Player is currently hardcoded for prototyping.
- This feature demonstrates the full flow:
  location tracking -> region detection -> capture logic -> UI update
- Other features (alliances, profile, etc.) are scaffolded.

