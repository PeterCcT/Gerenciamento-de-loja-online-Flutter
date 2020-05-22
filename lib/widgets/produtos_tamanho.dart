import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirtual/widgets/tamanho_dialog.dart';

class ProdutoTamanho extends FormField<List> {
  ProdutoTamanho({
    List initialValue,
    BuildContext context,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 34,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5,
                      ),
                      children: state.value
                          .map(
                            (e) => GestureDetector(
                              onLongPress: () {
                                state.didChange(state.value..remove(e));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                      color: Colors.purpleAccent,
                                      width: 2,
                                    )),
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                          .toList()
                            ..add(
                              GestureDetector(
                                onTap: () async {
                                  String tamanho = await showDialog(
                                      context: context,
                                      builder: (context) => AddTamanhoDialog());
                                  if (tamanho != null)
                                    state.didChange(state.value..add(tamanho));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(
                                        color: state.hasError
                                            ? Colors.red
                                            : Colors.purpleAccent,
                                        width: 2,
                                      )),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    child: state.hasError
                        ? Text(
                            state.errorText,
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )
                        : Container(),
                  ),
                ],
              );
            });
}
