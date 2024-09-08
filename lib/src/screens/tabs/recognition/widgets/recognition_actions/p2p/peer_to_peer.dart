import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/failure_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/loading_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/success_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/employee_item.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/list_employees.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/select_point.dart';
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

  Employee? _selectedRecipient;
  double _pointValue = 200;
  String? _selectedRecognitionValue;

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
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        child: RefreshableWidget(
          onRefresh: () async {
            context.read<RecognitionBloc>().add(FetchListRecipients());
            context.read<RecognitionBloc>().add(FetchListRecognitionValues());
          },
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
            BlocBuilder<RecognitionBloc, RecognitionState>(
              builder: (context, state) {
                final isLoading = state.isLoadingListEmployees;
                final listFilteredEmployees = state.listEmployees
                    .where(
                      (element) =>
                          element.name
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()) ||
                          element.email
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()),
                    )
                    .toList();

                return ListEmployees(
                    isLoading: isLoading,
                    listEmployees: listFilteredEmployees,
                    onSelectEmployee: (employee) {
                      setState(() {
                        _selectedRecipient = employee;
                      });
                    });
              },
            ),
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
                    onChangePoint: (double value) {
                      setState(() {
                        _pointValue = value;
                      });
                    },
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            BlocBuilder<RecognitionBloc, RecognitionState>(
              builder: (context, state) {
                final isLoading = state.isLoadingRecognitionValues;
                final listRecognitionValues = state.listRecognitionValues;
                return SelectRecognitionValue(
                  isLoading: isLoading,
                  listRecognitionValues: listRecognitionValues,
                  selectedRecognitionValue: _selectedRecognitionValue,
                  onRecognitionValueChanged: (value) {
                    setState(() {
                      _selectedRecognitionValue = value;
                    });
                  },
                );
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
