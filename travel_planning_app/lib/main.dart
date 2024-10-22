import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Plan your trip in just 5 minutes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedCity;
  int? _selectedDuration;
  Map<String, dynamic>? _travelData;

  @override
  void initState() {
    super.initState();
    _loadTravelData().then((data) {
      setState(() {
        _travelData = data;
      });
    });
  }

  Future<Map<String, dynamic>> _loadTravelData() async {
    String jsonString = await rootBundle.loadString('assets/travel_data.json');
    return jsonDecode(jsonString);
  }


  void _startPlanning() {
    print('Selected city ID: $_selectedCity');
    print('Selected trip duration: $_selectedDuration');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanningPage(cityId: _selectedCity, duration: _selectedDuration, travelData: _travelData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_travelData != null)
              DropdownButton<String>(
                hint: const Text('Select a city'),
                value: _selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
                items: _travelData!['cities'].map<DropdownMenuItem<String>>((city) {
                  return DropdownMenuItem<String>(
                    value: city['cityId'],
                    child: Text('${city['cityName']} - ${city['cityCountry']}'),
                  );
                }).toList(),
              ),
            if (_selectedCity != null && _travelData != null)
              DropdownButton<int>(
                hint: const Text('Select a duration'),
                value: _selectedDuration,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                },
                items: _travelData!['cities']
                    .firstWhere((city) => city['cityId'] == _selectedCity)['trips']
                    .map<DropdownMenuItem<int>>((trip) {
                  return DropdownMenuItem<int>(
                    value: trip['tripDuration'],
                    child: Text('${trip['tripDuration']} days'),
                  );
                }).toList(),
              )
            ,
            ElevatedButton(
              onPressed: (_selectedCity != null && _selectedDuration != null) ? _startPlanning : null,
              child: const Text('Start planning'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanningPage extends StatefulWidget {
  final String? cityId;
  final int? duration;
  final Map<String, dynamic>? travelData;

  PlanningPage({Key? key, this.cityId, this.duration, this.travelData}) : super(key: key);

  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> with SingleTickerProviderStateMixin {
  late List<dynamic> _events;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    var city = widget.travelData!['cities'].firstWhere((city) => city['cityId'] == widget.cityId);
    var trip = city['trips'].firstWhere((trip) => trip['tripDuration'] == widget.duration);
    _events = trip['daysOfTraveling'][0]['events'];

    _tabController = TabController(length: trip['daysOfTraveling'].length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      var city = widget.travelData!['cities'].firstWhere((city) => city['cityId'] == widget.cityId);
      var trip = city['trips'].firstWhere((trip) => trip['tripDuration'] == widget.duration);
      setState(() {
        _events = trip['daysOfTraveling'][_tabController.index]['events'];
      });
    }
  }

  void _addEvent() {
    final _formKey = GlobalKey<FormState>();
    String eventName = '';
    String geographicalCoordinates = '0° N, 0° E';
    int duration = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    eventName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Geographical Coordinates'),
                  onSaved: (value) {
                    geographicalCoordinates = value ?? geographicalCoordinates;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Duration'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    duration = int.tryParse(value ?? '') ?? duration;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _events.add({
                      'eventName': eventName,
                      'geographicalCoordinates': geographicalCoordinates,
                      'duration': duration,
                      'comments': [],
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editEvent(int index) {
    final _formKey = GlobalKey<FormState>();
    String eventName = _events[index]['eventName'];
    String geographicalCoordinates = _events[index]['geographicalCoordinates'];
    int duration = _events[index]['duration'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: eventName,
                  decoration: InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    eventName = value!;
                  },
                ),
                TextFormField(
                  initialValue: geographicalCoordinates,
                  decoration: InputDecoration(labelText: 'Geographical Coordinates'),
                  onSaved: (value) {
                    geographicalCoordinates = value ?? geographicalCoordinates;
                  },
                ),
                TextFormField(
                  initialValue: duration.toString(),
                  decoration: InputDecoration(labelText: 'Duration'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    duration = int.tryParse(value ?? '') ?? duration;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _events[index] = {
                      'eventName': eventName,
                      'geographicalCoordinates': geographicalCoordinates,
                      'duration': duration,
                      'comments': '',
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addComment(int eventIndex) {
    String comment = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _events[eventIndex]['comments'].add(comment);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _moveEventUp(int index) {
    if (index > 0) {
      setState(() {
        var event = _events[index];
        _events.removeAt(index);
        _events.insert(index - 1, event);
      });
    }
  }

  void _moveEventDown(int index) {
    if (index < _events.length - 1) {
      setState(() {
        var event = _events[index];
        _events.removeAt(index);
        _events.insert(index + 1, event);
      });
    }
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var city = widget.travelData!['cities'].firstWhere((city) => city['cityId'] == widget.cityId);
    var trip = city['trips'].firstWhere((trip) => trip['tripDuration'] == widget.duration);

    return DefaultTabController(
      length: trip['daysOfTraveling'].length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${city['cityName']} - ${city['cityCountry']}'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: trip['daysOfTraveling'].map<Tab>((day) => Tab(text: day['dayName'])).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: trip['daysOfTraveling'].map<Widget>((day) {
            return ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                var event = _events[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () => _moveEventUp(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () => _moveEventDown(index),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Tooltip(
                            message: 'Coordinates: ${event['geographicalCoordinates']}\n'
                                     'Duration: ${event['duration']} minutes\n'
                                     'Comments: \n\t- ${event['comments'].join('\n\t- ')}',
                            child: Text(event['eventName']),
                          ),
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () => _editEvent(index),
                      // ),
                      IconButton(
                        icon: Icon(Icons.add_comment),
                        onPressed: () => _addComment(index),
                      ),
                    ],
                  ),
                  subtitle: TextButton(
                    child: Text('Delete'),
                    onPressed: () => _deleteEvent(index),
                  ),
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _addEvent,
        ),
      ),
    );
  }
}
