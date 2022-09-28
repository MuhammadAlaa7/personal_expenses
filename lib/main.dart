import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {

  // SystemChrome.setPreferredOrientations(
  //     [
  //       DeviceOrientation.portraitUp,
  //       DeviceOrientation.portraitDown,
  //     ]
  // );
    runApp(const MyApp());

}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.normal,
            fontSize: 28,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Colors.purple,
          primary: Colors.indigoAccent,
          error: Colors.red,

        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount,
      DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(addTx: _addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool showChart = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    bool isLandscape = mq.orientation == Orientation.landscape;
    AppBar appBar = AppBar(
      title: const Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Column(


        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if(!isLandscape)
            SizedBox(
                height: (mq
                    .size
                    .height -
                    appBar.preferredSize.height -
                    mq.padding
                        .top) *
                    0.3,
                child: Chart(recentTransactions: _recentTransactions)),
           SizedBox(
            height: (mq
                .size
                .height -
                appBar.preferredSize.height -
                mq
                    .padding
                    .top) *
                0.7,
            child: TransactionList(
              deleteTx: _deleteTransaction,
              transactions: _userTransactions,
            ),
          ),

          if(isLandscape)
          Switch(
            value: showChart ,
            onChanged: (newValue ) {
              setState(() {
                showChart = newValue;
              });
            },
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
          if(isLandscape)
           showChart ?
           SizedBox(
              height: (mq
                  .size
                  .height -
                  appBar.preferredSize.height -
                  mq
                      .padding
                      .top) *
                  0.3,
              child: Chart(recentTransactions: _recentTransactions))
          : SizedBox(
            height: (mq
                .size
                .height -
                appBar.preferredSize.height -
                mq
                    .padding
                    .top) *
                0.3,
            child: TransactionList(
              deleteTx: _deleteTransaction,
              transactions: _userTransactions,
            ),
          ),






        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
