import 'package:flutter/material.dart';
import '../domain/category.dart';

/// Predefined expense categories.
abstract final class CategoriesData {
  static const food = ExpenseCategory(
    id: 'food',
    name: 'Food & Dining',
    icon: Icons.restaurant_outlined,
  );

  static const groceries = ExpenseCategory(
    id: 'groceries',
    name: 'Groceries',
    icon: Icons.shopping_cart_outlined,
  );

  static const transport = ExpenseCategory(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car_outlined,
  );

  static const rent = ExpenseCategory(
    id: 'rent',
    name: 'Rent',
    icon: Icons.home_outlined,
  );

  static const utilities = ExpenseCategory(
    id: 'utilities',
    name: 'Bills & Utilities',
    icon: Icons.bolt_outlined,
  );

  static const entertainment = ExpenseCategory(
    id: 'entertainment',
    name: 'Entertainment',
    icon: Icons.movie_outlined,
  );

  static const health = ExpenseCategory(
    id: 'health',
    name: 'Health',
    icon: Icons.favorite_border_outlined,
  );

  static const shopping = ExpenseCategory(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag_outlined,
  );

  static const all = <ExpenseCategory>[
    food,
    groceries,
    transport,
    rent,
    utilities,
    entertainment,
    health,
    shopping,
  ];

  static ExpenseCategory findById(String id) {
    return all.firstWhere((c) => c.id == id, orElse: () => food);
  }
}
