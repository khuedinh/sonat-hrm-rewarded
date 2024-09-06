import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/failure_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/loading_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/success_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/employee_item.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/list_employees.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/p2p/select_point.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/select_recognition_value.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';

class PeerToPeer extends StatefulWidget {
  const PeerToPeer({super.key});

  @override
  State<PeerToPeer> createState() => _PeerToPeerState();
}

class _PeerToPeerState extends State<PeerToPeer> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<Employee> _listEmployees = [];
  List<RecognitionValue> _listRecognitionValues = [];
  bool _isLoading = true;
  Employee? _selectedRecipient;
  double _pointValue = 200;
  String? _selectedRecognitionValue;

  void _handleChangePointValue(double value) {
    setState(() {
      _pointValue = value;
    });
  }

  Future<void> _fetchEmployees() async {
    final response = await RecognitionApi.getEmployees();
    final recognitionValueResponse =
        await RecognitionApi.getRecognitionValues();
    setState(() {
      _listEmployees = (response as List)
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList();
      _listRecognitionValues = (recognitionValueResponse as List).map((item) {
        return RecognitionValue.fromJson(item as Map<String, dynamic>);
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _sendRecognition() async {
    final data = {
      "recognitionValueId": _selectedRecognitionValue,
      "detailRecognitions": [
        {
          "recipientEmail": _selectedRecipient?.email,
          "point": _pointValue,
        }
      ],
      "message": _messageController.text.trim(),
      "type": "peer_to_peer"
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialog();
      },
    );

    try {
      await RecognitionApi.sendRecognition(data);
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const SuccessDialog(
              message: "Sended successfully",
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const FailureDialog(
              message: 'Failed to send recognition.',
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final listSearchedEmployees = _listEmployees
        .where(
          (element) =>
              element.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              element.email
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()),
        )
        .sorted((a, b) => compareAsciiUpperCase(a.name, b.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const ScreenTitle(title: "P2P recognition"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        height: 64,
        color: theme.colorScheme.surface,
        child: FilledButton(
          onPressed: () {
            if (_selectedRecognitionValue == null ||
                _selectedRecipient == null) {
              return;
            }
            _sendRecognition();
          },
          child: Text(
            'Send now',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Enter email or name',
                  prefixIcon: Icon(Icons.search, size: 28),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: ScreenTitle(
                title: "List recipients",
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ListEmployees(
                isLoading: _isLoading,
                listEmployees: listSearchedEmployees,
                onSelectEmployee: (employee) {
                  setState(() {
                    _selectedRecipient = employee;
                  });
                }),
            if (_selectedRecipient != null)
              SliverToBoxAdapter(
                child: ScreenTitle(
                  title: "Selected recipient",
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            if (_selectedRecipient != null)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 90,
                  child: EmployeeItem(
                    imageUrl: _selectedRecipient!.picture,
                    name: _selectedRecipient!.name,
                  ),
                ),
              ),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final isCurrentLoadingBalance = state.isLoadingCurrentBalance;
                final currentBalance = state.currentBalance;
                return SliverToBoxAdapter(
                  child: SelectPoint(
                    isLoading: isCurrentLoadingBalance,
                    balance: currentBalance?.currentPoint ?? 0,
                    value: _pointValue,
                    onChangePoint: _handleChangePointValue,
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SelectRecognitionValue(
              isLoading: _isLoading,
              listRecognitionValues: _listRecognitionValues,
              selectedRecognitionValue: _selectedRecognitionValue,
              onRecognitionValueChanged: (value) {
                setState(() {
                  _selectedRecognitionValue = value;
                });
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: ScreenTitle(
                title: 'Recognition message',
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Type message',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
