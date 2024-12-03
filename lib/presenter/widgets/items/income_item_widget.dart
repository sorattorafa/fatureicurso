import 'package:fatureicurso/domain/models/monthly_expenses.dart';
import 'package:flutter/material.dart';

class IncomeItemWidget extends StatelessWidget {
  const IncomeItemWidget({
    super.key,
    required this.income,
    required this.onEdit,
    required this.onDelete,
    required this.onDone,
  });

  final Income income;
  final Function onEdit;
  final Function onDelete;
  final Function onDone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /*
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Ação para editar
                      onEdit(income);
                      Navigator.pop(context);
                    },
                  ),
                  */
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Ação para deletar
                          onDelete(income);
                          Navigator.pop(context);
                        },
                      ),
                      const Text('Apagar'),
                    ],
                  ),
                  if (income.doneDate == null)
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.done),
                          onPressed: () {
                            // Ação para compartilhar
                            onDone();
                            Navigator.pop(context);
                          },
                        ),
                        const Text('Receber'),
                      ],
                    )
                  else
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.undo),
                          onPressed: () {
                            // Ação para compartilhar
                            onDone();
                            Navigator.pop(context);
                          },
                        ),
                        const Text('Desfazer Recebimento'),
                      ],
                    )
                ],
              ),
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(income.title[0].toUpperCase()),
        ),
        title: Text(income.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(
          'R\$ ${income.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: income.doneDate != null
            ? Text('Entrou dia: ${income.doneDate}')
            : Text('Entra dia: ${income.dueDate}'),
      ),
    );
  }
}
