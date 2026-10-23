import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  bool isIncome = false;

  final transactions = [
    {
      'title': 'Groceries',
      'date': 'Today',
      'amount': 500,
      'isIncome': false,
      'icon': Icons.shopping_cart,
    },

    {
      'title': 'Salary',
      'date': 'Yesterday',
      'amount': 8000,
      'isIncome': true,
      'icon': Icons.account_balance_wallet,
    },

    {
      'title': 'Transport',
      'date': 'Monday',
      'amount': 100,
      'isIncome': false,
      'icon': Icons.directions_bus,
    },
  ];
 Future<void> _editTransaction(int index) async {
    final editTitle = TextEditingController(
      text: transactions[index]['title'].toString(),
    );
    final editAmount = TextEditingController(
      text: transactions[index]['amount'].toString(),
    );
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Transaction'),

          content: Column(
mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: editTitle,
                decoration: InputDecoration(labelText: 'transaction title'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: editAmount,
                decoration: InputDecoration(labelText: 'transaction amount'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                final updateTitle = editTitle.text.trim();
                final updateAmount = int.tryParse(editAmount.text);
                if (updateTitle.isEmpty ||
                    updateAmount == null ||
                    updateAmount < 0) {
                  print("Enter a valid title and amount");
                  return;
                }
                setState(() {
                  transactions[index]['title'] = updateTitle;
                  transactions[index]['amount'] = updateAmount;
                });

                Navigator.pop(context);
              },
              child: Text('save'),
            ),
          ],
        );
      },
    );
    editTitle.dispose();
    editAmount.dispose();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = transactions
        .where((transaction) {
          return transaction['isIncome'] == true;
          // Keep only income transactions
        })
        .fold<int>(0, (sum, transaction) {
          // Add each income amount to sum
          return sum + (transaction['amount'] as int);
        });

    final totalExpenses = transactions
        .where((transaction) {
          // Keep only expenses
          return transaction['isIncome'] == false;
        })
        .fold<int>(0, (sum, transaction) {
          // Add the expense amount
          return sum + (transaction['amount'] as int);
        });

    final expensePercentage = totalIncome > 0
        ? (totalExpenses / totalIncome) *
              100 // calculate the percentage here
        : 0.0;

    final totalBalance = totalIncome - totalExpenses;

    final progressValue = (expensePercentage / 100).clamp(0.0, 1.0);

    final transactionWidgets = ListView.separated(
      itemCount: transactions.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return TransactionTile(
          title: transactions[index]['title'] as String,
          date: transactions[index]['date'] as String,
          amount: transactions[index]['amount'] as int,
          isIncome: transactions[index]['isIncome'] as bool,
          icon: transactions[index]['icon'] as IconData,
          onDelete: () {
            setState(() {
              transactions.removeAt(index);
            });
          },

onEdit: () {
 
    _editTransaction(index);
  
},

        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('FinTrack.'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${NumberFormat('#,##0').format(totalBalance)} ETB',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),

                        Text(
                          'Available Balance',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,

                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),
                              Text(
                                '${NumberFormat('#,##0').format(totalIncome)} ETB',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          height: 140,

                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Expenses",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${NumberFormat('#,##0').format(totalExpenses)} ETB',
                                style: TextStyle(fontSize: 20),
                              ),

                              SizedBox(height: 4),
                              Text(
                                'income spent: ${expensePercentage.toStringAsFixed(1)}%',
                              ),
                              LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: Colors.grey.shade100,
                                color: Colors.red,
                                minHeight: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Add Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Transaction title',
                      hintText: 'e.g Groceries or Salary',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (ETB)',
                      hintText: "Enter amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  DropdownButtonFormField<bool>(
                    initialValue: isIncome,

                    decoration: InputDecoration(
                      labelText: 'Transaction type',
                      border: OutlineInputBorder(),
                    ),

                    items: [
                      DropdownMenuItem(value: false, child: Text('Expense')),

                      DropdownMenuItem(value: true, child: Text('Income')),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          isIncome = value;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      final title = titleController.text;
                      final int? amount = int.tryParse(amountController.text);

                      if (title.trim().isEmpty ||
                          amount == null ||
                          amount <= 0) {
                        final snackBar = SnackBar(
                          content: const Text(
                            'Enter a valid title and an amount greater than zero',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      final newTransaction = {
                        'title': title,
                        'date': 'today',
                        'amount': amount,
                        'isIncome': isIncome,
                        'icon': isIncome
                            ? Icons.account_balance_wallet
                            : Icons.shopping_cart,
                      };

                      setState(() {
                        transactions.add(newTransaction);
                        isIncome = false;
                      });
                      // Action to perform

                      titleController.clear();
                      amountController.clear();
                    },
                    child: Text('Add Transaction'),
                  ),

                  SizedBox(height: 24),
                  Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  transactionWidgets,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final int amount;
  final bool isIncome;
  final IconData icon;
  final VoidCallback onDelete;
final VoidCallback onEdit;
  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final formattedAmount = formatter.format(amount.abs());
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isIncome ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isIncome ? '+ $formattedAmount ETB' : '- $formattedAmount ETB',
            style: TextStyle(color: isIncome ? Colors.green : Colors.red),
          ),

          IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
          IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
        ],
      ),
    );
  }
}
