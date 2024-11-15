import 'package:flutter/material.dart';

class FarmersSection extends StatefulWidget {
  const FarmersSection({super.key});

  @override
  State<FarmersSection> createState() => _FarmersSectionState();
}

class _FarmersSectionState extends State<FarmersSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fullName = '';
  DateTime dateOfBirth = DateTime.now();
  String gender = 'Male';
  String phoneNumber = '';
  String email = '';
  String address = '';
  String farmLocation = '';

  bool _formSubmitted = false; // To check if the form has been submitted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Farmer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formSubmitted
                ? _buildTable() // Display table if form is submitted
                : _buildForm(), // Otherwise, show form
          ],
        ),
      ),
    );
  }

  // Build the form to take user input
  Widget _buildForm() {
    return Expanded(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Full Name Field
              _buildTextField(
                label: 'Full Name',
                onSaved: (value) => fullName = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 12),

              // Phone Number Field
              _buildTextField(
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                onSaved: (value) => phoneNumber = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 12),

              // Email Field
_buildTextField(
  label: 'Email(Optional)',
  keyboardType: TextInputType.emailAddress,
  onSaved: (value) => email = value ?? '',
  validator: (value) {
    // Make email field optional
    if (value != null && value.isNotEmpty && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
),
              const SizedBox(height: 12),

              // Address Field
              _buildTextField(
                label: 'Address',
                onSaved: (value) => address = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 12),

              // Farm Location Field
              _buildTextField(
                label: 'Farm Location',
                onSaved: (value) => farmLocation = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter your farm location' : null,
              ),
              const SizedBox(height: 12),

              // Date of Birth Field
              _buildDateField(
                label: 'Date of Birth',
                onSaved: (value) => dateOfBirth = value ?? dateOfBirth,
              ),
              const SizedBox(height: 12),

              // Gender Dropdown
              _buildDropdownField(
                label: 'Gender',
                value: gender,
                onChanged: (newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: ['Male', 'Female', 'Other'],
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _formSubmitted = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40), backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), // Green color for the button
                  ),
                  child: Text(
                    'Save Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label bold
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  // Helper method to build dropdown field
  Widget _buildDropdownField({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }

  // Helper method to build Date of Birth field (looks like a regular text field)
  Widget _buildDateField({
    required String label,
    required FormFieldSetter<DateTime> onSaved,
  }) {
    return TextFormField(
      readOnly: true, // Makes the text field read-only
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      controller: TextEditingController(text: '${dateOfBirth.toLocal()}'.split(' ')[0]), // Display the selected date
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: dateOfBirth,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != dateOfBirth)
          setState(() {
            dateOfBirth = pickedDate;
          });
      },
      onSaved: (value) {
        onSaved(dateOfBirth); // Save the selected date
      },
    );
  }

  // Widget to display table after form submission
  Widget _buildTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Farmer Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        Table(
          border: TableBorder.all(),
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            _buildTableRow("Full Name", fullName),
            _buildTableRow("Date of Birth", '${dateOfBirth.toLocal()}'.split(' ')[0]),
            _buildTableRow("Gender", gender),
            _buildTableRow("Phone Number", phoneNumber),
            _buildTableRow("Email", email),
            _buildTableRow("Address", address),
            _buildTableRow("Farm Location", farmLocation),
          ],
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _formSubmitted = false; // Reset to show the form again
              });
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40), backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ), // Green color for the button
            ),
            child: Text(
              'Edit Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build each row in the table
  TableRow _buildTableRow(String label, String value) {
        return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}

