import 'package:flutter/material.dart';

enum Status {
  paid,
  due,
  waitingDate,
}


Widget getIncomeDate(String? dayString) {
  if (dayString == null) {
    return Container();
  }
  final DateTime now = DateTime.now();
  final int day = int.parse(dayString);
  final DateTime date = DateTime(now.year, now.month, day);

  final DateTime dateOnly = DateTime(date.year, date.month, date.day);
  final DateTime nowOnly = DateTime(now.year, now.month, now.day);

  if (dateOnly.isAfter(nowOnly)) {
    return Text(
      'Entra em ${dateOnly.difference(nowOnly).inDays} dias',
      style: const TextStyle(color: Colors.green),
    );
  } else if (dateOnly.isAtSameMomentAs(nowOnly)) {
    return const Text(
      'Entra hoje',
      style:  TextStyle(color: Colors.red),
    );
  } else {
    return Text(
      'Entrou há ${nowOnly.difference(dateOnly).inDays} dias',
      style: const TextStyle(color: Colors.red),
    );
  }
}

Widget getDueDate(String? dayString) {
  if (dayString == null) {
    return Container();
  }
  final DateTime now = DateTime.now();
  final int day = int.parse(dayString);
  final DateTime date = DateTime(now.year, now.month, day);

  final DateTime dateOnly = DateTime(date.year, date.month, date.day);
  final DateTime nowOnly = DateTime(now.year, now.month, now.day);

  if (dateOnly.isAfter(nowOnly)) {
    return Text(
      'Vence em ${dateOnly.difference(nowOnly).inDays} dias',
      style: const TextStyle(color: Colors.green),
    );
  } else if (dateOnly.isAtSameMomentAs(nowOnly)) {
    return const Text(
      'Vence hoje',
      style:  TextStyle(color: Colors.red),
    );
  } else {
    return Text(
      'Vencido há ${nowOnly.difference(dateOnly).inDays} dias',
      style: const TextStyle(color: Colors.red),
    );
  }
}

Text getStatus(String dayString) {
  final DateTime now = DateTime.now();
  // Convertendo a string de dia para inteiro e criando um objeto DateTime com o ano e mês atual e o dia fornecido
  final int day = int.parse(dayString);
  final DateTime date = DateTime(now.year, now.month, day);

  // Criando novos objetos DateTime com apenas ano, mês e dia para comparação
  final DateTime dateOnly = DateTime(date.year, date.month, date.day);
  final DateTime nowOnly = DateTime(now.year, now.month, now.day);

  if (dateOnly.isAfter(nowOnly)) {
    return const Text(
      'Aguardando data',
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold),
    );
  } else if (dateOnly.isAtSameMomentAs(nowOnly)) {
    return const Text(
      'Vence hoje',
      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
    );
  } else {
    return const Text(
      'Vencido',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
