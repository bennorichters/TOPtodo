import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toptodo/blocs/incident/bloc.dart';
import 'package:toptodo/utils/td_colors.dart';
import 'package:toptodo/widgets/td_button.dart';
import 'package:toptodo/widgets/td_shape.dart';

class IncidentForm extends StatelessWidget {
  IncidentForm(this.state);
  final IncidentState state;

  final _formKey = GlobalKey<FormState>();

  final _verticalSpace = const SizedBox(height: 10);
  final _briefDescription = TextEditingController();
  final _request = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TdShapeBackground(
      longSide: LongSide.bottom,
      color: TdColors.squash,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _briefDescription,
                decoration: InputDecoration(labelText: 'Brief description'),
                validator: (value) =>
                    value.isEmpty ? 'Fill in a brief description' : null,
              ),
              _verticalSpace,
              TextFormField(
                controller: _request,
                decoration: InputDecoration(labelText: 'Request'),
                maxLength: null,
                maxLines: null,
              ),
              _verticalSpace,
              // TODO: don't allow resubmit before state has been received that
              // request is processed.
              // Check what happens in case of error (like time out) does form 
              // keep data? 
              (state is SubmittingIncident)
                  ? CircularProgressIndicator()
                  : TdButton(
                      text: 'submit',
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          BlocProvider.of<IncidentBloc>(context)
                            ..add(
                              IncidentSubmit(
                                briefDescription: _briefDescription.text,
                                request: _request.text,
                              ),
                            );
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
