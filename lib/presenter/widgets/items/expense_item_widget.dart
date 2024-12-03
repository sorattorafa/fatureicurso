import 'package:fatureicurso/domain/models/monthly_expenses.dart';
import 'package:flutter/material.dart';

class ExpenseItemWidget extends StatelessWidget {
  const ExpenseItemWidget({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
    required this.onDone,
  });

  final Expense expense;
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
                      onEdit(expense);
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
                          onDelete(expense);
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Apagar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  if (expense.doneDate == null)
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
                        const Text(
                          'Pagar',
                          style: TextStyle(color: Colors.black),
                        ),
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
                        const Text('Remover Pagamento')
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(expense.title[0].toUpperCase()),
        ),
        title: Text(expense.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(
          'R\$ ${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: expense.doneDate != null
            ? Text('Pago dia: ${expense.doneDate}')
            : expense.isRecurring && DateTime.now().day > expense.dueDate!
                ? Text(
                    'Vencido à ${DateTime.now().day - expense.dueDate!} dias')
                : expense.isRecurring
                    ? Text('Vence dia: ${expense.dueDate}')
                    : null,
      ),
    );
  }
}
