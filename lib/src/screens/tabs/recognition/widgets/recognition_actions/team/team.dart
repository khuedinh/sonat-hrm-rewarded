import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sonat_hrm_rewarded/src/common/blocs/user/user_bloc.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/failure_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/loading_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/api_call_status_indicator/success_dialog.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/refreshable_widget/refreshable_widget.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/list_employees.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/select_point.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/select_recognition_value.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/team/list_group.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition_actions/team/select_more_recipient.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<Employee> _selectedRecipients = [];
  String? _selectedRecognitionValue;
  String? _selectedGroup;
  double _pointValue = 200;
  bool _isSavePresets = false;
  bool _isLoadingGroupDetails = false;

  Future<void> _selectGroup(Group group) async {
    setState(() {
      _isLoadingGroupDetails = true;
      _selectedGroup = group.id;
    });
    final response = await RecognitionApi.getGroupMembers(group.id);
    final groupDetails =
        GroupDetails.fromJson(response as Map<String, dynamic>);
    final members =
        groupDetails.memberGroups.map((item) => item.employee).toList();

    if (mounted) {
      setState(() {
        _selectedRecipients.clear();
        _selectedRecipients.addAll(members);
        _isLoadingGroupDetails = false;
      });
    }
  }

  void _handleAddMoreRecipients() async {
    final selectedRecipient = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BlocBuilder<RecognitionBloc, RecognitionState>(
          builder: (context, state) {
            final isLoading = state.isLoadingListEmployees;
            final listEmployees = state.listEmployees;

            return SelectMoreRecipient(
              isLoading: isLoading,
              listEmployees: listEmployees,
              initSelectedRecipients: _selectedRecipients,
            );
          },
        );
      },
    );

    if (selectedRecipient != null) {
      setState(() {
        _selectedRecipients.clear();
        _selectedRecipients.addAll(selectedRecipient);
      });
    }
  }

  Future<void> _sendRecognition() async {
    final data = {
      "recognitionValueId": _selectedRecognitionValue,
      "detailRecognitions": _selectedRecipients.map((employee) {
        return {
          "recipientEmail": employee.email,
          "point": _pointValue,
        };
      }).toList(),
      "message": "",
      "type": "team",
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

      if (_isSavePresets) {
        final presetData = {
          "emails": _selectedRecipients.map((item) => item.email).toList(),
          "name": _groupNameController.text,
          "id": _selectedGroup,
        };

        if (_selectedGroup != null) {
          await RecognitionApi.updateGroup(_selectedGroup!, presetData);
        } else {
          await RecognitionApi.createGroup(presetData);
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuccessDialog(
              message: AppLocalizations.of(context)!.sent_successfully,
            );
          },
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMessage = e.response?.data['message'] ??
            AppLocalizations.of(context)!.failed_to_send;
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FailureDialog(
              message: errorMessage,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title:
            ScreenTitle(title: AppLocalizations.of(context)!.team_recogntion),
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
            _sendRecognition();
          },
          child: Text(
            AppLocalizations.of(context)!.send_now,
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
            context.read<RecognitionBloc>().add(FetchListGroups());
          },
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: ScreenTitle(
                title: AppLocalizations.of(context)!.groups,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            BlocBuilder<RecognitionBloc, RecognitionState>(
              builder: (context, state) {
                final isLoading = state.isLoadingListGroups;
                final listGroups = state.listGroups;
                return ListGroups(
                  isLoading: isLoading,
                  listGroups: listGroups,
                  selectedGroup: _selectedGroup,
                  onSelectGroup: (group) async {
                    if (_selectedGroup == group.id) {
                      setState(() {
                        _selectedGroup = null;
                        _selectedRecipients.clear();
                      });
                      return;
                    }
                    await _selectGroup(group);
                  },
                );
              },
            ),
            SliverToBoxAdapter(
              child: ScreenTitle(
                title: AppLocalizations.of(context)!.selected_recipients,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ListEmployees(
              isShowAddMore: true,
              isLoading: _isLoadingGroupDetails,
              listEmployees: _selectedRecipients,
              onSelectEmployee: (employee) {},
              onAddMoreRecipients: _handleAddMoreRecipients,
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.save_as_preset),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: _isSavePresets,
                      onChanged: (bool value) {
                        setState(() {
                          _isSavePresets = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isSavePresets && _selectedGroup == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _groupNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      hintText: AppLocalizations.of(context)!.enter_group_name,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
              ),
            BlocBuilder<UserBloc, UserState>(builder: (context, state) {
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
            }),
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
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ],
        ),
      ),
    );
  }
}
