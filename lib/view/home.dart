import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_03_shopping_list_app/service/database_service.dart';
import 'package:task_03_shopping_list_app/model/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _nameController;
  List<Item> items = [];
  late final DatabaseService? _dbService;

  @override
  void initState() {
    super.initState();
    _dbService = DatabaseService.instance;
    fetchItems();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<List<Item>> fetchItems() async {
    if (_dbService != null) {
      items = await _dbService.getItems();
      setState(() {});
    }
    return items;
  }

  Future<void> _addItem() async {
    if (_dbService != null && _nameController.text.isNotEmpty) {
      bool inserted =
          await _dbService.insertItem(Item(name: _nameController.text.trim()));

      if (inserted) {
        _nameController.clear();
        Navigator.pop(context);
        await fetchItems();
        setState(() {});
      }
    } else {
      log('Database Service is Null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Shopping List'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddDialog, child: const Icon(Icons.add)),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: ValueKey<int>(item.id!),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      padding: const EdgeInsets.only(right: 40),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) async {
                      if (_dbService != null) {
                        bool isDeleted = await _dbService.deleteItem(item);
                        if (isDeleted) {
                          items = await fetchItems();
                          setState(() {});
                        }
                      } else {
                        log('DB is null');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(item.name),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add an Item'),
          content: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                fillColor: Colors.grey.shade100,
                hintText: 'Tomatoes',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true),
            keyboardType: TextInputType.name,
          ),
          actions: [TextButton(onPressed: _addItem, child: const Text('Add'))],
        );
      },
    );
  }
}
