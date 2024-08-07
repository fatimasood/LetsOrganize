import 'package:attendence_sys/Admin/UpdateRecord.dart';
import 'package:attendence_sys/AppBar/CustomAppBar.dart';
import 'package:attendence_sys/Student/MarkAt.dart';
import 'package:attendence_sys/Student/databaseHelper.dart';
import 'package:attendence_sys/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ViewRecordA extends StatefulWidget {
  const ViewRecordA({Key? key}) : super(key: key);

  @override
  _ViewRecordAState createState() => _ViewRecordAState();
}

class _ViewRecordAState extends State<ViewRecordA> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _loadAttendanceRecords() async {
    final records = await _databaseHelper.getAllAttendanceRecords();
    setState(() {
      attendanceRecords = records.cast<AttendanceRecord>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: 170),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20, top: 15.0, bottom: 5.8),
                child: Text(
                  "Welcome to the Admin Portal. Here is all your task with necessary info. ",
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 89, 48, 170),
                    ),
                  ),
                ),
              ),
              for (var record in attendanceRecords)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 21, 9),
                  child: Container(
                    width: 340,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(248, 238, 238, 238),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3f000000),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        title: Text(
                          '${record.firstName} ${record.lastName}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_formatDate(record.date)}'),
                            Text(
                              'Status: ${record.isPresent ? 'To DO' : 'In Progress'}',
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateRecord(),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.green,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateRecord(),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () async {
                                print('Delete button pressed');
                                // Show a confirmation dialog before deleting
                                bool deleteConfirmed = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Record'),
                                      content: Text(
                                        'Are you sure you want to delete this record?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(false); // Cancel delete
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pop(true); // Confirm delete
                                            // Delete the record from the database by date
                                            if (record.date != null) {
                                              await _databaseHelper
                                                  .deleteAttendanceRecord(
                                                record.date,
                                              );
                                            } else {
                                              print(
                                                'Record date is null, cannot delete.',
                                              );
                                            }

                                            // Remove the record from the UI
                                            setState(() {
                                              attendanceRecords.remove(record);
                                            });
                                            print('Record removed from UI');
                                            Utils().toastMessage(
                                                'Data Deleted...!!');
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                print('Delete Confirmed: $deleteConfirmed');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarkAttendence(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xffc780ff),
      ),
    );
  }
}
