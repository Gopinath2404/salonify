import 'package:flutter/material.dart';
import '../services/firebase_database_service.dart';

// Location model
class Location {
  final String id;
  final String name;
  final String city;

  Location({required this.id, required this.name, required this.city});
}

class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Location> _allLocations = [];
  List<Location> _filteredLocations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get all salons from Firebase
      final salonService = firebaseDatabaseService;
      final salons = await salonService.getSalons();
      
      // Extract unique locations from salons
      Set<String> uniqueLocations = {};
      List<Location> locations = [];
      int idCounter = 1;
      
      for (var salon in salons) {
        // Add unique locations
        if (!uniqueLocations.contains(salon.location)) {
          uniqueLocations.add(salon.location);
          locations.add(Location(
            id: idCounter.toString(),
            name: salon.location, // Use location as both name and city for now
            city: salon.location,
          ));
          idCounter++;
        }
      }
      
      setState(() {
        _allLocations = locations;
        _filteredLocations = _allLocations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading locations: $e');
      setState(() {
        _isLoading = false;
        // Fallback to some default locations if loading fails
        _allLocations = [
          Location(id: '1', name: 'New York', city: 'New York'),
          Location(id: '2', name: 'Miami', city: 'Miami'),
          Location(id: '3', name: 'Los Angeles', city: 'Los Angeles'),
        ];
        _filteredLocations = _allLocations;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading locations: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _allLocations;
      } else {
        _filteredLocations = _allLocations.where((location) {
          return location.name.toLowerCase().contains(query.toLowerCase()) ||
              location.city.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search field
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterLocations,
                  decoration: InputDecoration(
                    hintText: 'Search locations...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Location list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : _filteredLocations.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No locations found',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredLocations.length,
                            itemBuilder: (context, index) {
                              final location = _filteredLocations[index];
                              return Card(
                                color: Theme.of(context).colorScheme.surface,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    location.name,
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    location.city,
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  onTap: () {
                                    // Navigate to salon list screen with selected location
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/salon-list',
                                      arguments: location,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
