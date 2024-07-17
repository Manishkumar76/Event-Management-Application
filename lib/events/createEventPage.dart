import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/Models/event_model.dart';
import 'package:project/Services/event_services.dart';
import 'package:project/Services/special_services.dart';
import 'package:project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../Models/Categories_model.dart';
import '../Models/Depart_model.dart';
import '../Models/venue_model.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _mainImage;
  DateTime? _eventRegisterStartDate;
  DateTime? _eventRegisterEndDate;
  DateTime? _eventStartDate;
  DateTime? _eventEndDate;
  TimeOfDay? _eventStartTime;
  int? _selectedDepartmentId;
  int? _selectedVenueId;
  int? _selectedCategoryId;
  List<Department> _departments = [];
  List<Categories> _categories = [];
  List<Venue> _venues = [];

  int? userId;

  Future<void> _fetchUserID() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getInt('user_id');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserID();
    _fetchDepartments();
    _fetchCategories();
    _fetchVenues();
  }

  Future<void> _fetchDepartments() async {
    try {
      SpecialServices specialServices = SpecialServices();
      List<Department> departments = await specialServices.getDepartment();
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      print('Failed to load departments: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      SpecialServices specialServices = SpecialServices();
      List<Categories> categories = await specialServices.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Failed to load Categories: $e');
    }
  }

  Future<void> _fetchVenues() async {
    try {
      List<Venue> venues = await SpecialServices().getAllvenues();
      setState(() {
        _venues = venues;
      });
    } catch (e) {
      print('Failed to load venues: $e');
    }
  }

  Future<void> _pickDate(BuildContext context, Function(DateTime) onSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  Future<void> _pickTime(BuildContext context, Function(TimeOfDay) onSelected) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _mainImage = File(image.path);
      });
    }
  }

  void _createEvent() async {
    print("Creating event...");
    if (_formKey.currentState?.validate() ?? false) {
      if (_eventRegisterStartDate == null ||
          _eventRegisterEndDate == null ||
          _eventStartDate == null ||
          _eventEndDate == null ||
          _selectedDepartmentId == null ||
          _selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the required fields')),
        );
        return;
      }

      Event event = Event(
        id: 0, // Placeholder, replace with actual ID generation logic
        mainImage: _mainImage?.path ?? 'assets/images/placeholder.png',
        photo1: '', // Placeholder
        photo2: '', // Placeholder
        name: _nameController.text,
        description: _descriptionController.text,
        eventRegisterStartDate: _eventRegisterStartDate!,
        eventRegisterEndDate: _eventRegisterEndDate!,
        eventStartDate: _eventStartDate!,
        eventEndDate: _eventEndDate!,
        eventStartTime: _eventStartTime?.format(context) ?? '09:00:00',
        totalParticipant: 0, // Placeholder, replace with actual value
        departmentId: _selectedDepartmentId ?? 0,
        categoryId: _selectedCategoryId ?? 0,
        organizerId: userId!,
        venueId: _selectedVenueId ?? 0,
      );

      print("Event data: ${event.toJson()}");

      await EventServices().createEvent(event).then((createdEvent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MainPage()));
        print('Event created: ${createdEvent.id}');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create event')),
        );
        print('Failed to create event: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(12),
                          child: _mainImage == null
                              ? Container()
                              : Image.file(
                            _mainImage!,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 50,
                          bottom: 50,
                          left: 50,
                          right: 50,
                          child: _mainImage == null
                              ? const Column(
                            children: [
                              Icon(Icons.upload_file, size: 40, color: Colors.black),
                              Text("Upload Image", style: TextStyle(color: Colors.black)),
                            ],
                          )
                              : const Column(
                            children: [
                              Icon(Icons.upload, size: 50, color: Colors.white),
                              Text("Upload New Image", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedDepartmentId,
                items: _departments.map((department) {
                  return DropdownMenuItem<int>(
                    value: department.id,
                    child: Text(department.dep_name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartmentId = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedVenueId,
                items: _venues.map((venue) {
                  return DropdownMenuItem<int>(
                    value: venue.id,
                    child: Text(venue.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVenueId = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Venue'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a venue';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Event Register Start Date'),
                subtitle: Text(_eventRegisterStartDate != null
                    ? _eventRegisterStartDate!.toLocal().toString().split(' ')[0]
                    : 'Select Date'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, (date) {
                  setState(() {
                    _eventRegisterStartDate = date;
                  });
                }),
              ),
              ListTile(
                title: const Text('Event Register End Date'),
                subtitle: Text(_eventRegisterEndDate != null
                    ? _eventRegisterEndDate!.toLocal().toString().split(' ')[0]
                    : 'Select Date'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, (date) {
                  setState(() {
                    _eventRegisterEndDate = date;
                  });
                }),
              ),
              ListTile(
                title: Text('Event Start Date: ${_eventStartDate != null ? _eventStartDate!.toLocal().toString().split(' ')[0] : ''}'),
                trailing: const Icon(Icons.calendar_today),
                subtitle: Text(_eventStartDate != null
                    ? _eventStartDate!.toLocal().toString().split(' ')[0]
                    : 'Select Date'),
                onTap: () => _pickDate(context, (date) {
                  setState(() {
                    _eventStartDate = date;
                  });
                }),
              ),
              ListTile(
                title: Text('Event End Date: ${_eventEndDate != null ? _eventEndDate!.toLocal().toString().split(' ')[0] : ''}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, (date) {
                  setState(() {
                    _eventEndDate = date;
                  });
                }),
              ),
              ListTile(
                title: Text('Event Start Time: ${_eventStartTime != null ? _eventStartTime!.format(context) : ''}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context, (time) {
                  setState(() {
                    _eventStartTime = time;
                  });
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

