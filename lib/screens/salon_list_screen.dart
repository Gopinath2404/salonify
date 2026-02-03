import 'package:flutter/material.dart';
import 'location_selector_screen.dart';
import '../models/salon_model.dart';
import '../services/firebase_database_service.dart';

class SalonListScreen extends StatefulWidget {
  final Location? selectedLocation;

  const SalonListScreen({Key? key, this.selectedLocation}) : super(key: key);

  @override
  State<SalonListScreen> createState() => _SalonListScreenState();
}

class _SalonListScreenState extends State<SalonListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Salon> _allSalons = [];
  List<Salon> _filteredSalons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalons();
  }

  void _loadSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final salonService = firebaseDatabaseService;
      _allSalons = await salonService.getSalons();

      // Filter salons by location if a location is selected
      if (widget.selectedLocation != null) {
        _allSalons = _allSalons.where((salon) {
          return salon.location.toLowerCase().contains(
                widget.selectedLocation!.name.toLowerCase(),
              ) &&
              salon.isActive; // Only show active salons in the selected location
        }).toList();
      } else {
        // If no location is selected, show all active salons
        _allSalons = _allSalons.where((salon) => salon.isActive).toList();
      }

      setState(() {
        _filteredSalons = _allSalons;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading salons: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading salons: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterSalons(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSalons = _allSalons;
      } else {
        _filteredSalons = _allSalons.where((salon) {
          return salon.name.toLowerCase().contains(query.toLowerCase()) ||
              salon.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedLocation?.name ?? 'Salons'),
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
                  onChanged: _filterSalons,
                  decoration: InputDecoration(
                    hintText: 'Search salons...',
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

              // Salon list
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : _filteredSalons.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_florist_outlined,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No salons found',
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
                        itemCount: _filteredSalons.length,
                        itemBuilder: (context, index) {
                          final salon = _filteredSalons[index];
                          return Card(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Salon image
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: salon.imageUrls.isNotEmpty
                                      ? Image.network(
                                          salon.imageUrls.first,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                // Fallback to default image if URL fails
                                                return Container(
                                                  height: 200,
                                                  width: double.infinity,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.business,
                                                    size: 64,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.1),
                                          child: Icon(
                                            Icons.business,
                                            size: 64,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Salon name
                                      Text(
                                        salon.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 8),
                                      // Location
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            salon.location,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.7),
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      // Description
                                      Text(
                                        salon.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      // Action button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Navigate to booking screen
                                            Navigator.pushNamed(
                                              context,
                                              '/booking',
                                              arguments: salon
                                                  .name, // Pass salon name to booking screen
                                            );
                                          },
                                          child: Text('View Services'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
