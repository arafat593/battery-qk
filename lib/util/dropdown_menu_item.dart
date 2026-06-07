
class DropDownMenuItemList {
  static final List<String> location = [
    'New York',
    'London',
    'Dubai',
    'Tokyo',
    'Berlin',
    'Toronto',
    'Paris',
    'Other',
  ];
  static final List<String> ageGroup = [
    'Toddlers (0-5 years)',
    'Children (6-12 years)',
    'Teenagers (13-18 years)',
    'Adults (18+)',
  ];
  static final List<String> rating = [
    '1 Star',
    '2 Stars',
    '3 Stars',
    '4 Stars',
    '5 Stars',
  ];
  static final List<String> gender = [
    'Male',
    'Female',
    'Other'
  ];
  static final List<String> price = [
    'Paid',
    'Pending',
  ];
  static Map<String, Map<String, Map<String, bool>>> sportsCategories = {
    'A. Individual Sports': {
      'A.1 Combat Sports': {
        'Karate': false,
        'Taekwondo': false,
        'Judo': false,
        'Kung Fu': false,
        'Boxing': false,
        'MMA': false,
      },
      'A.2 Water Sports': {
        'Swimming': false,
        'Diving': false,
        'Rowing': false,
        'Kayaking': false,
        'Surfing': false,
      },
      'A.3 Artistic & Performance': {
        'Gymnastics': false,
        'Ballet': false,
        'Modern Dance': false,
        'Ice Skating': false,
      },
      'A.4 Mind & Strategy': {
        'Chess': false,
        'Shooting': false,
        'Archery': false,
        'Table Tennis': false,
      },
      'A.5 Strength & Endurance': {
        'Weightlifting': false,
        'Running': false,
        'Mountain Climbing': false,
        'CrossFit': false,
        'Road Cycling': false,
      },
      'A.6 Modern or Mixed': {
        'Parkour': false,
        'Calisthenics': false,
      },
      'A.7 Other Individual': {
        'Aerial/Balance Sports': false,
        'Indoor Wall Climbing': false,
        'Slacklining': false,
      },
    },
    'B. Team Sports': {
      'B.1 Ball Sports': {
        'Football': false,
        'Basketball': false,
        'Volleyball': false,
        'Handball': false,
        'Baseball': false,
      },
      'B.2 Team Water Sports': {
        'Water Polo': false,
        'Aqua Football': false,
      },
      'B.3 Group Artistic Sports': {
        'Group Gymnastics': false,
        'Group Dance': false,
      },
      'B.4 Winter Team Sports': {
        'Ice Hockey': false,
        'Group Ski Racing': false,
      },
      'B.5 Mixed/Contact Team Sports': {
        'Rugby': false,
        'American Football': false,
      },
      'B.6 Other Team Sports': {
        'Dodgeball': false,
        'Ultimate Frisbee': false,
        'Capture the Flag': false,
      },
    }
  };

}
