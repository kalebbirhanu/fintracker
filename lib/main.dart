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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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

    final transactionWidgets = ListView.separated(
      itemCount: transactions.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final formatter = NumberFormat('#,##0');
        final amount = transactions[index]['amount'] as int;
        final amountText = transactions[index]['isIncome'] == true
            ? '+ ${formatter.format(amount.abs())}'
            : '- ${formatter.format(amount.abs())}';
        return ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: transactions[index]['isIncome'] == true
                  ? Colors.green.shade100
                  : Colors.red.shade100,
            ),
            child: Icon(
              transactions[index]['icon'] as IconData,

              color: transactions[index]['isIncome'] == true
                  ? Colors.green.shade800
                  : Colors.red.shade800,
            ),
          ),

          title: Text(transactions[index]['title'].toString()),
          subtitle: Text(transactions[index]['date'].toString()),
          trailing: Text(
            '$amountText ETB',

            style: TextStyle(
              color: transactions[index]['isIncome'] == true
                  ? Colors.green
                  : Colors.red,
            ),
          ),
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
                          'ETB 25,000.00',
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
                          height: 120,

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
                              Text('ETB 8000', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          height: 120,

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
                              Text("ETB 5,000", style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final formattedAmount = formatter.format(amount.abs());
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isIncome ? const Color.fromARGB(255, 8, 10, 8) : Colors.red,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        isIncome ? '+ $formattedAmount ETB' : '- $formattedAmount ETB',
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
    );
  }
}
