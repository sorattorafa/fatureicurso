import 'dart:convert';

class MonthlyTransaction {
  final String id;
  final String title;
  final double amount;
  final int? dueDate;
  final String type; // "expense" ou "income"
  final bool isRecurring;
  String? doneDate;


  MonthlyTransaction({
    required this.id,
    required this.title,
    required this.amount,
    this.dueDate,
    required this.type,
    required this.isRecurring,
    this.doneDate,
  });

  factory MonthlyTransaction.fromJson(Map<String, dynamic> json) {
    return MonthlyTransaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      dueDate: json['dueDate'],
      type: json['type'],
      isRecurring: json['isRecurring'],
      doneDate: json['doneDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'dueDate': dueDate,
      'type': type,
      'isRecurring': isRecurring,
      'doneDate': doneDate,
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}

class Expense extends MonthlyTransaction {
  Expense({
    required super.id,
    required super.title,
    required super.amount,
    super.dueDate,
    super.doneDate,
    required super.isRecurring,
  }) : super(
          type: 'expense',
        );

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      dueDate: json['dueDate'],
      isRecurring: json['isRecurring'],
      doneDate: json['doneDate'],
    );
  }

  factory Expense.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Expense.fromJson(jsonMap);
  }
}

class Income extends MonthlyTransaction {
  Income({
    required super.id,
    required super.title,
    required super.amount,
    super.dueDate,
    super.doneDate,
    required super.isRecurring,
  }) : super(
          type: 'income',
        );

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      dueDate: json['dueDate'],
      isRecurring: json['isRecurring'],
      doneDate: json['doneDate'],
    );
  }

  factory Income.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Income.fromJson(jsonMap);
  }
}