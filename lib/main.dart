import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(UserInformationApp());
}

class UserInformationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Information Form',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: UserInformationScreen(),
    );
  }
}

class UserInformationScreen extends StatefulWidget {
  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _gender = '';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _age = '';
  String _bmi = '';
  String _bmiComment = '';
  String _result = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Calculate Age
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(_selectedDate);
      int age = (difference.inDays / 365).floor();
      _age = age.toString();

      // Calculate BMI
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text) / 100;
      double bmi = weight / (height * height);
      _bmi = bmi.toStringAsFixed(2);

      // BMI Comment
      if (bmi >= 25) {
        _bmiComment = 'You are overweight.';
      } else if (bmi < 18.5) {
        _bmiComment = 'You are underweight.';
      } else {
        _bmiComment = 'Your weight is within a healthy range.';
      }

      // Print Information
      _result = 'User Name: ${_userNameController.text}\n'
          'Address: ${_addressController.text}\n'
          'Gender: $_gender\n'
          'Date of Birth: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}\n'
          'Weight: ${_weightController.text} kg\n'
          'Height: ${_heightController.text} cm\n'
          'Age: $_age\n'
          'BMI: $_bmi\n'
          'BMI Comment: $_bmiComment';

      setState(() {});
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _weightValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your weight.';
    }
    double? weight = double.tryParse(value);
    if (weight == null || weight <= 0 || weight > 500) {
      return 'Invalid weight. Please enter a valid weight.';
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _userNameController.clear();
    _addressController.clear();
    _gender = '';
    _selectedDate = DateTime.now();
    _weightController.clear();
    _heightController.clear();
    _age = '';
    _bmi = '';
    _bmiComment = '';
    _result = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your user name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Gender',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: Row(
                  children: [
                    Icon(Icons.male), // Add icon for male
                    SizedBox(
                        width: 8.0), // Add some spacing between icon and text
                    Text('Male'),
                  ],
                ),
                value: 'Male',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Row(
                  children: [
                    Icon(Icons.female), // Add icon for female
                    SizedBox(
                        width: 8.0), // Add some spacing between icon and text
                    Text('Female'),
                  ],
                ),
                value: 'Female',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.line_weight),
                ),
                keyboardType: TextInputType.number,
                validator: _weightValidator,
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your height.';
                  }
                  double? height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Invalid height. Please enter a valid height.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: _resetForm,
                    child: Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                _result,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
