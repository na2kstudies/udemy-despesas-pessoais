import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime? selectedDate = DateTime.now();

  _submitForm() {
    final title = titleController.text;
    final valueText = valueController.text.replaceAll(',', '.');
    final value = double.tryParse(valueText) ?? 0.0;

    if (title.isEmpty || value <= 0 || selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
              controller: valueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitForm(),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data Selecionada: ${DateFormat.yMMMMd('pt_BR').format(selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: const Text('Selecionar Data'),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  //comentário 1: você pode escolher a forma que preferir, pegando da cor que setamos no nosso Theme:
                  // style: ElevatedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     backgroundColor: Theme.of(context).primaryColor),
                  //comentário 2: ou setar a cor que você preferir diretamente:
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.purple),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Nova Transação',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
